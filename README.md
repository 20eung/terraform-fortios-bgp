# terraform-fortios-vpn-bgp-sdwan
Terraform으로 FortiGete 장비에서 Azure VPN Gateway와 IPsec VPN 연동, BGP 라우팅 연동, SDWAN 구성하는 방법입니다.

> ### Diagram
![Diagram](./img/diagram.png "Diagram")

> ### Provider 설정

[ Terraform과 FortiOS 연동 ](https://github.com/20eung/terraform-fortios-howto) 바로가기

> ### main.tf 설명
모듈 module 로 호출
변수로 다음 정보를 전달함
* Azure VPN 정보
* US Site 정보
* SDWAN에서 SLA 측정을 하기 위한 Azure 서버 IP 정보


#terraform #fortinet #fortigate #fortios #ipsec #vpn #bgp #sdwan #sd-wan
