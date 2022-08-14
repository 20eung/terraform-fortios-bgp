azure_us_vpns           = [
    {name = "azure-us-1", remote_gw = "20.118.94.253",  local_ip = "10.242.189.1 255.255.255.255", bgp_ip = "10.242.187.13", asn = "65515" },
    {name = "azure-us-2", remote_gw = "20.118.94.241",  local_ip = "10.242.189.3 255.255.255.255", bgp_ip = "10.242.187.12", asn = "65515" },
]

us_site                 = {
    vpn_ip              = "49.50.63.182"
    bgp_asn             = "65001"
    bgp_ip              = "10.92.129.1"
    cidr                = "10.92.129.0/24"
    cidr_fg             = "10.92.129.0 255.255.255.0"
    tunnel1_ip          = "10.242.189.1"
    tunnel2_ip          = "10.242.199.3"
}

# Azure US Linux VM
sla_server              = "10.242.190.68"
