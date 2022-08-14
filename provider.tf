terraform {

    required_providers {
        fortios	= {
	        source	= "fortinetdev/fortios"
	    }
    }
}

provider "fortios" {
#   credentials_file = "~/.fortiosrc"
#   include credentials_file to .bashrc
#
#   $ cat ~/.bashrc | grep fortiosrc
#   if [ -f ~/.fortiosrc ]; then
#       . ~/.fortiosrc
#   if
#
#   $ cat ~/.fortiosrc
#   export "FORTIOS_ACCESS_HOSTNAME"="49.50.63.182"
#   export "FORTIOS_ACCESS_TOKEN"="b3Hgt1d70445sQpmhrNx9d855n6nGb"
#   export "FORTIOS_INSECURE"="true"
#   export "FORTIOS_CA_CABUNDLE"="/home/ubuntu/.ssh/cloud9-terraform.crt"
#
#   or include below in this file
#
#    hostname        = "49.50.63.182"
#    token           = "b3Hgt1d70445sQpmhrNx9d855n6nGb"
#    insecure        = "true"
#    cabundlefile    = "/home/ubuntu/.ssh/cloud9-terraform.crt"
}