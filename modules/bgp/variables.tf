variable "azure_vpns" {
        type = list(object({
        name        = string
        remote_gw   = string
        local_ip    = string
        bgp_ip      = string
        asn         = string
    }))
}

variable "us_site" {
    type = object({
        vpn_ip      = string
        bgp_asn     = string
        bgp_ip      = string
        cidr        = string
        cidr_fg     = string
        tunnel1_ip  = string
        tunnel2_ip  = string
    })
}

variable sla_server {}