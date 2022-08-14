module "fortios_us_vpn" {
#    source              = "./modules/fortios/static"
#    local_gw_ip         = var.us_site.vpn_ip

    source              = "./modules/bgp"

    
    azure_vpns          = var.azure_us_vpns
    us_site             = var.us_site
    sla_server          = var.sla_server
}
