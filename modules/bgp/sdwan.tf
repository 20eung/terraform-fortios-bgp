# Enable SD-WAN
resource "fortios_system_sdwan" "this" {
    status              = "enable"
    # Select the implicit SD-WAN algorithm
    load_balance_mode   = "source-dest-ip-based"


# Add interfaces as members
    members {
        seq_num         = "1"
        interface       = "azure-us-1"
        gateway         = var.us_site.tunnel1_ip
        status          = "enable"
    }
    members {
        seq_num         = "2"
        interface       = "azure-us-2"
        gateway         = var.us_site.tunnel2_ip
        status          = "enable"
    }
    
    # Configure a performance SLA
    health_check {
        name                = "globalwan_vm"
        server              = var.sla_server
        sla_fail_log_period = "30"
        sla_pass_log_period = "60"
        update_static_route = "enable"
        members {
            seq_num         = "1"
        }
        members {
            seq_num         = "2"
        }
        sla {
            id              = "1"
            latency_threshold   = "200"
        }
    }
    
    depends_on		        = [fortios_system_interface.azure-us-1, fortios_system_interface.azure-us-2]
}


# Create a firewall policy for SD-WAN
resource "fortios_firewall_policy" "us_site_vlan-to-sdwan" {
    name                = "us_site_vlan-to-sdwan"
    srcintf   { name	= "us_site_vlan" }
    dstintf   { name	= "virtual-wan-link" }
    srcaddr   { name	= "all" }
    dstaddr   { name	= "all" }
    action		        = "accept"
    schedule		    = "always"
    service   { name	= "ALL" }
    nat                 = "disable"
    tcp_mss_sender      = "1350"
    tcp_mss_receiver    = "1350"
    logtraffic          = "all"
}

resource "fortios_firewall_policy" "sdwan-to-us_site_vlan" {
    name                = "sdwan-to-us_site_vlan"
    srcintf   { name	= "virtual-wan-link" }
    dstintf   { name	= "us_site_vlan" }
    srcaddr   { name	= "all" }
    dstaddr   { name	= "all" }
    action		        = "accept"
    schedule		    = "always"
    service   { name	= "ALL" }
    nat                 = "disable"
    tcp_mss_sender      = "1350"
    tcp_mss_receiver    = "1350"
    logtraffic          = "all"
}

