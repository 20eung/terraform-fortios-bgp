## Terraform 코드를 FortiGate config로 표현하면 아래와 같습니다.

> vpn.tf
```
config vpn ipsec phase1-interface
    edit "azure-us-1"
        set interface "wan1"
        set ike-version 2
        set keylife 28800
        set peertype any
        set net-device disable
        set proposal aes128-sha1 3des-sha1 aes256-sha256
        set dpd on-idle
        set dhgrp 2
        set nattraversal disable
        set remote-gw 20.20.20.1
        set psksecret VPNSecret!
        set dpd-retryinterval 10
    next
    edit "azure-us-2"
        set interface "wan1"
        set ike-version 2
        set keylife 28800
        set peertype any
        set net-device disable
        set proposal aes128-sha1 3des-sha1 aes256-sha256
        set dpd on-idle
        set dhgrp 2
        set nattraversal disable
        set remote-gw 20.20.20.2
        set psksecret VPNSecret!
        set dpd-retryinterval 10
    next
end

config vpn ipsec phase2-interface
    edit "azure-us-1"
        set phase1name "azure-us-1"
        set proposal aes128-sha1 3des-sha1 aes256-sha256
        set pfs disable
        set auto-negotiate enable
        set keylifeseconds 27000
    next
    edit "azure-us-2"
        set phase1name "azure-us-2"
        set proposal aes128-sha1 3des-sha1 aes256-sha256
        set pfs disable
        set auto-negotiate enable
        set keylifeseconds 27000
    next
end
```

> firewall_policy.tf
```
config firewall policy
    edit 0
        set name "us_site_vlan-to-azure"
        set srcintf "us_site_vlan"
        set dstintf "azure-us-1" "azure-us-2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
#       set tcp-mss-sender 1350
#       set tcp-mss-receiver 1350
    next
    edit 0
        set name "azure-to-us_site_vlan"
        set srcintf "azure-us-1" "azure-us-2"
        set dstintf "us_site_vlan"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
#       set tcp-mss-sender 1350
#       set tcp-mss-receiver 1350
    next
end 
```
    
> system_interface.tf
```
config system interface
    edit "azure-us-1"
        set vdom "root"
        set ip 10.242.189.12 255.255.255.255
        set allowaccess ping
        set type tunnel
        set tcp-mss 1350
        set remote-ip 10.242.187.12 255.255.255.255
        set interface "wan1"
    next
    edit "azure-us-2"
        set vdom "root"
        set ip 10.242.189.13 255.255.255.255
        set allowaccess ping
        set type tunnel
        set tcp-mss 1350
        set remote-ip 10.242.187.13 255.255.255.255
        set interface "wan1"
    next
end
```

> route.tf
```
config router access-list
    edit "tunnel1"
        config rule
            edit 1
                set prefix 10.242.189.12 255.255.255.255
            next
            edit 2
                set prefix 10.92.129.0 255.255.255.0
            next
        end
    next
    edit "tunnel2"
        config rule
            edit 1
                set prefix 10.242.189.13 255.255.255.255
            next
            edit 2
                set prefix 10.92.129.0 255.255.255.0
            next
        end
    next
end

config router bgp
    set as 65001
    set router-id 50.50.50.50
    set ebgp-multipath enable
    config neighbor
        edit "10.242.187.12"
            set ebgp-enforce-multihop enable
            set soft-reconfiguration enable
            set distribute-list-out "tunnel1"
            set remote-as 65515
        next
        edit "10.242.187.13"
            set ebgp-enforce-multihop enable
            set soft-reconfiguration enable
            set distribute-list-out "tunnel2"
            set remote-as 65515
        next
    end
    config network
        edit 1
            set prefix 10.242.189.12 255.255.255.255
        next
        edit 2
            set prefix 10.242.189.13 255.255.255.255
        next
        edit 3
            set prefix 10.92.129.0 255.255.255.0
        next
    end
end

```

> sdwan.tf
```
config system sdwan
    set status enable
    set load-balance-mode source-dest-ip-based
    config zone
        edit "virtual-wan-link"
        next
    end
    config members
        edit 1
            set interface "azure-us-1"
            set gateway 10.242.189.12
        next
        edit 2
            set interface "azure-us-2"
            set gateway 10.242.199.13
        next
    end
    config health-check
        edit "sla_server"
            set server "10.242.190.68"
            set sla-fail-log-period 30
            set sla-pass-log-period 60
            set members 1 2
            config sla
                edit 1
                    set latency-threshold 200
                next
            end
        next
    end
end
```

---
#terraform #fortinet #fortigate #fortios #ipsec #vpn #bgp #sdwan #sd-wan
