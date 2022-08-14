resource "fortios_router_accesslist" "tunnel1" {
    name     = "tunnel1"
    rule {
        id                  = "1"
        prefix              = "${lookup(var.azure_vpns[0], "local_ip")}"
        exact_match         = "enable"
    }
    rule {
        id                  = "2"
        prefix              = var.us_site.cidr_fg
        exact_match         = "enable"
    }
}

resource "fortios_router_accesslist" "tunnel2" {
    name     = "tunnel2"
    rule {
        id                  = "1"
        prefix              = "${lookup(var.azure_vpns[1], "local_ip")}"
        exact_match         = "enable"
    }
    rule {
        id                  = "2"
        prefix              = var.us_site.cidr_fg
        exact_match         = "enable"
    }
}

resource "fortios_router_bgp" "bgp" {
    as                      = 65001
    router_id               = var.us_site.vpn_ip
    ebgp_multipath          = "enable"
    
#    redistribute {
#        name                = "connected"
#        status              = "enable"
#    }
}

resource "fortios_routerbgp_neighbor" "azure-us-1" {
    ip                      = "${lookup(var.azure_vpns[0], "bgp_ip")}"
    remote_as               = "${lookup(var.azure_vpns[0], "asn")}"
    soft_reconfiguration    = "enable"
    distribute_list_out     = "tunnel1"
    ebgp_enforce_multihop   = "enable"
    
    depends_on              = [fortios_vpnipsec_phase2interface.azure-us-1]
}

resource "fortios_routerbgp_neighbor" "azure-us-2" {
    ip                      = "${lookup(var.azure_vpns[1], "bgp_ip")}"
    remote_as               = "${lookup(var.azure_vpns[1], "asn")}"
    soft_reconfiguration    = "enable"
    distribute_list_out     = "tunnel2"
    ebgp_enforce_multihop   = "enable"
    
    depends_on              = [fortios_vpnipsec_phase2interface.azure-us-2]
}

resource "fortios_routerbgp_network" "tunnel1" {
#   fosid                   = 1
    prefix                  = "${lookup(var.azure_vpns[0], "local_ip")}"
}

resource "fortios_routerbgp_network" "tunnel2" {
#   fosid                   = 1
    prefix                  = "${lookup(var.azure_vpns[1], "local_ip")}"
}

resource "fortios_routerbgp_network" "us_site" {
#   fosid                   = 1
    prefix                  = var.us_site.cidr_fg
}
