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

> ### modules/vpn.tf 설명
* FortiOS를 사용하려면 module 에서도 provider 설정이 필요합니다.
* Azure VPN 연동 권장 설정

|설정|권장 값|
|-----------|---------|
|IKE Version|2|
|dpd|on-idle|
|keylife|28800|
|proposal|aes128-sha1 3des-sha1 aes256-sha256|
|dhgrp|2|
|dpd_retryinterval|10|
|nattraversal|disable|

[ FortiOF Cookbook ](https://docs.fortinet.com/document/fortigate/6.2.11/cookbook/255100/ipsec-vpn-to-azure) 바로가기


#terraform #fortinet #fortigate #fortios #ipsec #vpn #bgp #sdwan #sd-wan
