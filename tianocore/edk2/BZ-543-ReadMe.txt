What is it?
-----------
   HttpBoot Driver originally provides  system boot in DHCP service with IPV4 and IPv6 support. With attached enhancement HttpBoot Driver provides static IP address
   in URI (DevicePath Type) in Home Environment . System should boot without DHCP service with IPV4 and IPv6 support.
   HttpBoot Driver designed with support DHCP service in DevicePath Type Input which is given in Uri.
  
DESIGN:
-------
    IPv4 and IPv6 Device path is got by user through Uri,so that Uri additionly supports DevicePath type as mentioned in test procedure,
    It has already supports http and https.This Input Devicepath is updated to HttpBootoption Device path.    
    HttpBoot configured LocalIP Address,GatewayIp Address,Dns serverIP Address using Device path, 
   
Test Requirements:
----------------- 

1. SUT with Bios Image having UEFI Network Stack Module.
2. Test Server which has HTTP server configured in it.
3. LAN Cables connected to the SUT and the Test Server with the help of Switch /hub


                          
                           IPV6 Static HttpBoot and DHCP HttpBoot
			   --------------------------------------
Test Procedures:
----------------

1. Power on the system and boot to Setup.
2. Go to Advanced Tab and Select Network Stack configuration, Set Network Stack as Enabled.Enable IPv6 HTTP Support
3. Save the changes and reboot the SUT
4. Go to Advanced Tab and Select HTTP Boot Configuration, Change the control values like below
Input the Description -> UEFI_HTTP_IPv6
Internet Protocol -> IP6
Boot URI -> Ipv6(LocalIpAddress,Tcp,static or dhcp,GatewayIpAddress)/Dns(IP1,IP2,IP3...IPn)/Uri(http://Serverip/EFI/Shell.efi)
Note:strings in IPv4,Tcp,static,dhcp,dns are not case sensitive.
please refer Supported Uri's Below,

4. Assign Invalid Ip address for localIp ,gateway and Dnsserverip in Uri.
5. Gave Invalid Uri Format.
5. Save the changes and reboot the SUT
6. Now go to the Boot tab and under boot options select the UEFI_HTTP_IPv6.


                           IPV4 Static HttpBoot and DHCP HttpBoot
			   --------------------------------------
Test Procedures:
---------------

1. Power on the system and boot to Setup.
2. Go to Advanced Tab and Select Network Stack configuration, Set Network Stack as Enabled.Enable IPv4 HTTP Support
3. Save the changes and reboot the SUT
4. Go to Advanced Tab and Select HTTP Boot Configuration, Change the control values like below
Input the Description -> UEFI_HTTP_IPv4
Internet Protocol -> IP4
Boot URI -> Ipv4(LocalIpAddress,Tcp,static or dhcp,GatewayIpAddress,SubnetMask)/dns(IP1,IP2..IPn)/uri(http://DomainName/EFI/Shell.efi)

please refer Supported Uri's Below.
Note:strings in IPv4,Tcp,static,dhcp,dns are not case sensitive.
4. Assign Invalid Ip address for localIp ,gateway and DnsserverIp in Uri.
5. Provide Invalid Uri Format.
6. Save the changes and reboot the SUT
7. Now go to the Boot tab and under boot options select the UEFI_HTTP_IPv4.
Expected Results:

The System should boot to HTTP with Static IPv4 

Expected Results:
-----------------
4.System should PopUp messages with Invalid LocalIP or Invalid SubnetMask or Invalid GatewayIp.
5.System Should PopUp Messages with Invalid Uri.
The System should boot to HTTP with Static IPv6 address.

Supported Uri'S (IPV6 HttpBoot);
--------------------------------

IPV6 Static Httpboot:

1.Ipv6(2001:db8:0:1::200,tcp,static,0::0)/dns(2001:db8:0:1::1)/uri(http://www.cloudbootip6.com/EFI/Shellx64.efi)
2.Ipv6(2001:db8:0:1::200,tcp,static,0::0)/uri(http://[2001:db8:0:1::1]/EFI/Shellx64.efi)

IPv6 Dhcp HttpBoot:

For Dhcp localIp address and gatewayIP Address configured using DHCP Service,
so HttpBoot Driver doesn't take input from Uri ,If it is given with Proper IP Address also.
Thus It is filled with zeros,refers below example.

1.Ipv6(0::0,tcp,dhcp,0::0)/dns(0::0)/uri(http://www.cloudbootip6.com/EFI/Shellx64.efi)
2.Ipv6(0::0,tcp,dhcp,0::0)/uri(http://www.cloudbootip6.com/EFI/Shellx64.efi)
3.http://www.cloudbootip6.com/EFI/Shellx64.efi



Supported Uri'S (IPV6 HttpBoot);
--------------------------------

IPV4 Static HttpBoot:
1.Ipv4(172.31.18.10,tcp,static,172.31.18.1,255.255.255.0)/dns(172.31.18.15)/uri(http://www.cloudboot.com/EFI/Shellx64.efi)
2.1.Ipv4(172.31.18.10,tcp,static,172.31.18.1,255.255.255.0)/uri(http://172.31.18.15/EFI/Shellx64.efi)

IPv4 Dhcp Http Boot:
1. Ipv4(0.0.0.0,tcp,dhcp,0.0.0.0,0.0.0.0)/dns(0.0.0.0)/uri(http://www.cloudboot.com/EFI/Shellx64.efi)
2. Ipv4(0.0.0.0,tcp,dhcp,0.0.0.0,0.0.0.0)/uri(http://www.cloudboot.com/EFI/Shellx64.efi)
3. http://www.cloudboot.com/EFI/Shellx64.efi