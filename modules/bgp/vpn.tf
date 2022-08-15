terraform {
    required_providers {
        fortios	= {
	        source	= "fortinetdev/fortios"
	}
    }
}

resource "fortios_vpnipsec_phase1interface" "azure-us-1" {
  name			= "${lookup(var.azure_vpns[0], "name")}"
  interface		= "wan1"
  ike_version           = "2"
  dpd			= "on-idle"
  keylife		= 28800
  peertype		= "any"
  net_device	        = "disable"
  proposal		= "aes128-sha1 3des-sha1 aes256-sha256"
  dhgrp			= "2"
  remote_gw		= "${lookup(var.azure_vpns[0], "remote_gw")}"
  psksecret		= "VPNSecret!"
  dpd_retryinterval	= "10"
  nattraversal		= "disable"
}


# IPsec Phase2-interface 설정
resource "fortios_vpnipsec_phase2interface" "azure-us-1" {
  name			= fortios_vpnipsec_phase1interface.azure-us-1.name
  phase1name		= fortios_vpnipsec_phase1interface.azure-us-1.name
  proposal		= "aes128-sha1 3des-sha1 aes256-sha256"
  pfs			= "disable"
  auto_negotiate        = "enable"
  keylifeseconds	= 27000

  depends_on		= [fortios_vpnipsec_phase1interface.azure-us-1]
}

resource "fortios_vpnipsec_phase1interface" "azure-us-2" {
  name			= "${lookup(var.azure_vpns[1], "name")}"
  interface		= "wan1"
  ike_version           = "2"
  dpd			= "on-idle"
  keylife		= 28800
  peertype		= "any"
  net_device	        = "disable"
  proposal		= "aes128-sha1 3des-sha1 aes256-sha256"
  dhgrp			= "2"
  remote_gw		= "${lookup(var.azure_vpns[1], "remote_gw")}"
  psksecret		= "VPNSecret!"
  dpd_retryinterval	= "10"
  nattraversal		= "disable"
}


# IPsec Phase2-interface 설정
resource "fortios_vpnipsec_phase2interface" "azure-us-2" {
  name			= fortios_vpnipsec_phase1interface.azure-us-2.name
  phase1name		= fortios_vpnipsec_phase1interface.azure-us-2.name
  proposal		= "aes128-sha1 3des-sha1 aes256-sha256"
  pfs			= "disable"
  auto_negotiate        = "enable"
  keylifeseconds	= 27000

  depends_on		= [fortios_vpnipsec_phase1interface.azure-us-2]
}
