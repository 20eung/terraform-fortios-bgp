# 방화벽 정책 설정: 내부망 - 외부
resource "fortios_firewall_policy" "us_site_vlan-to-azure" {
  name			        = "us_site_vlan-to-azure"
  srcintf   { name	= "us_site_vlan" }
  dstintf   { name	= "azure-us-1" }
  dstintf   { name  = "azure-us-2" }
  srcaddr   { name	= "all" }
  dstaddr   { name	= "all" }
  action		        = "accept"
  schedule		      = "always"
  service   { name	= "ALL" }
  nat               = "disable"
  tcp_mss_sender    = "1350"
  tcp_mss_receiver  = "1350"
  logtraffic        = "all"

  depends_on        = [fortios_system_interface.azure-us-1, fortios_system_interface.azure-us-2, fortios_system_interface.us_site_vlan]
}

# 방화벽 정책 설정: 외부 - 내부망
resource "fortios_firewall_policy" "azure-to-us_site_vlan" {
  name			        = "azure-to-us_site_vlan"
  srcintf   { name	= "azure-us-1" }
  srcintf   { name  = "azure-us-2" }
  dstintf   { name	= "us_site_vlan" }
  srcaddr   { name	= "all" }
  dstaddr   { name	= "all" }
  action		        = "accept"
  schedule		      = "always"
  service   { name	= "ALL" }
  nat               = "disable"
  tcp_mss_sender    = "1350"
  tcp_mss_receiver  = "1350"
  logtraffic        = "all"

  depends_on		    = [fortios_system_interface.azure-us-1, fortios_system_interface.azure-us-2, fortios_system_interface.us_site_vlan]
}
