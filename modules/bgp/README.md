## Terraform 코드를 FortiGate config로 표현하면 아래와 같습니다.
#### FortiGate 60E Firmware v6.4.7 build1911(GA)에서 확인하였습니다.

> vpn.tf
```
config vpn ipsec phase1-interface
    edit "azure-1"
        set interface "wan1"
        set ike-version 2
        set keylife 28800
        set peertype any
        set net-device disable
        set proposal aes256-sha256
        set dpd on-idle
        set dhgrp 2
        set nattraversal disable
        set remote-gw 20.20.20.1
        set psksecret VPNSecret!
        set dpd-retryinterval 10
    next
    edit "azure-2"
        set interface "wan1"
        set ike-version 2
        set keylife 28800
        set peertype any
        set net-device disable
        set proposal aes256-sha256
        set dpd on-idle
        set dhgrp 2
        set nattraversal disable
        set remote-gw 20.20.20.2
        set psksecret VPNSecret!
        set dpd-retryinterval 10
    next
end

config vpn ipsec phase2-interface
    edit "azure-1"
        set phase1name "azure-1"
        set proposal aes256-sha256
        set pfs disable
        set auto-negotiate enable
        set keylifeseconds 27000
    next
    edit "azure-2"
        set phase1name "azure-2"
        set proposal aes256-sha256
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
        set name "internal-to-azure"
        set srcintf "internal"
        set dstintf "azure-1" "azure-2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 0
        set name "azure-to-internal"
        set srcintf "azure-1" "azure-2"
        set dstintf "internal"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
end 
```
    
> system_interface.tf
```
config system interface
    edit "azure-1"
        set vdom "root"
        set ip 10.242.189.12 255.255.255.255
        set allowaccess ping
        set type tunnel
        set tcp-mss 1350
        set remote-ip 10.242.187.12 255.255.255.255
        set interface "wan1"
    next
    edit "azure-2"
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

> firewall_policy.tf

## SDWAN 설정을 하기 위해서는 Firewall Policy를 먼저 삭제해야 함
## 아래 2개의 정책 삭제 후 진행해야 합니다.

```
config firewall policy
    edit 0
        set name "internal-to-azure"
        set srcintf "internal"
        set dstintf "azure-1" "azure-2"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
    edit 0
        set name "azure-to-internal"
        set srcintf "azure-1" "azure-2"
        set dstintf "internal"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
    next
end 
```

## 위 2개 정책 삭제 후 진행합니다.

```
config system sdwan
    set status enable
    config zone
        edit "virtual-wan-link"
        next
    end
end

config system sdwan
    config members
        edit 1
            set interface "azure-1"
            set gateway 10.242.189.12
        next
        edit 2
            set interface "azure-2"
            set gateway 10.242.199.13
        next
    end
end

config system sdwan
    config health-check
        edit "sla_server"
            set server "10.242.190.68"
            set interval 1000
            set members 1 2
            config sla
                edit 1
                    set latency-threshold 150
                    set jitter-threshold 30
                    set packetloss-threshold 2
                next
            end
        next
    end
end

config system sdwan
    config service
        edit 1
            set name "sla_check"
            set mode sla
            set dst "sla_server"
            config sla
                edit "sla_check"
                    set id 1
                next
            end
            set priority-members 1 2
        next
    end
end

```

---
#terraform #fortinet #fortigate #fortios #ipsec #vpn #bgp #sdwan #sd-wan
