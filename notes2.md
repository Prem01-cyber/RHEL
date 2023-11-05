- [Configuring Networks](#configuring-networks)
  - [Fundamentals](#fundamentals)
  - [Managing Network Address and Interfaces](#managing-network-address-and-interfaces)
    - [Ports and services](#ports-and-services)
  - [Network configuration](#network-configuration)
  - [Setting up hostname and DNS](#setting-up-hostname-and-dns)

# Configuring Networks
## Fundamentals
- IPV4 -> 32 bits -> 4 octets -> 192.168.10.132
- IPV6 -> 128 bits -> 8 octets -> 2001:0db8:85a3:0000:0000:8a2e:0370:7334
- IP address are used to identify a host on a network, below are private addresses range
  - 10.0.0.0/8      -> class A network
  - 172.168.0.0/16  -> class B network
  - 192.168.0.0/16  -> class C network
- NAT (Network Address Translation) is used to translate private IP addresses to public IP addresses
- MAC address is a hard coded physical address of a network interface card (NIC)
- MAC address is 48 bits long and is represented in hexadecimal format and it has two parts 
  - OUI (Organizationally Unique Identifier) -> first 24 bits
  - NIC specific part -> last 24 bits
- In order to communicate with other hosts on the network, a host must have an IP address and a MAC address
- Every webserver runs services, in order to identify and communicate with services, we use ports
- The way the communication should be done is decided using the protocols

## Managing Network Address and Interfaces
- `ip addr` -> shows the IP address and MAC address of all the network interfaces
  - `ip addr show eth0` -> shows the IP address and MAC address of eth0 interface
- `ip route` -> shows the routing table
  - `ip route show default` -> shows the default gateway
- `ip link` -> configure and monitor network link state
  - `ip link show eth0` -> shows the status of eth0 interface
  - `ip link set eth0 up` -> brings up the eth0 interface temporarily

- **loopback address** 127.0.0.1 is used for communication between processes

### Ports and services
- `netstat` -> shows the status of all the ports (**deprecated**)
  - `netstat -tulpn` -> shows the status of all the ports with the process name

- `ss` -> shows the status of all the ports
  - `ss -tulpn` -> shows the status of all the ports with the process name

## Network configuration
- RHEL is managed by **Network Manager** service
  - `systemctl status NetworkManager` -> shows the status of Network Manager service
  - `/etc/sysconfig/network-scripts` -> contains the network configuration files
    - `ifcfg-eth0` -> contains the configuration of eth0 interface (**Deprecated**)

- By default NetworkManger now uses the `key file` format to store new connection profiles under `/etc/NetworkManager/system-connections/`
- ![NetworkManager](assets/Screenshot%20from%202023-11-05%2008-09-57.png)

- Device is a NIC, a connection is a configuration used on the device
- Everything we do with ip command is temporary, if we wanna make permanent changes we do it using nmcli or nmtui

- `nmtui` -> network manager text user interface
- `nmcli` -> network manager command line interface
  - `nmcli connection show`                         -> shows the connection details
  - `nmcli connection show eth0`                    -> shows the connection details of eth0 interface
  - `nmcli connection modify eth0 ipv4.addresses`   -> modify the IP address of eth0 interface
  - `nmcli gen permissions`                         -> shows the permissions of the network manager
  - `nmcli device show ens160`                      -> shows the details of ens160 interface

- we can set both **fixed Ip** and **DHCP** using nmcli and nmtui
  - `nmcli connection modify eth0 ipv4.method manual ipv4.addresses` -> set fixed IP address (Manual indicated fixed IP)
  - `nmcli connection modify eth0 ipv4.method auto` -> set DHCP (auto indicates DHCP)

## Setting up hostname and DNS
- there are many ways to set the **hostname**
  1. `hostnamectl set-hostname <hostname>` -> set the hostname temporarily (`--static` option to make it permanent)
     - `hostnamectl status` -> shows the status of hostname
  2. `nmtui`
  3. `/etc/hostname` -> edit the contents to set the hostname 

- `hostname -f` -> shows the fully qualified domain name
- `/etc/hosts` -> contains the IP address and hostname mapping
  - we can use this file to configure the hostname resolution
  - All hostname IP address definitions as set in **/etc/hosts** will be applied **before the hostname in DNS** is used
  - This configured as a default in the hosts line of the **/etc/nsswitch.conf** file
  - ![nsswitch.conf](assets/Screenshot%20from%202023-11-05%2008-23-35.png)

- just editing the `/etc/hosts` file is not enough, we need to configure the DNS server
  1. we can use `nmtui` to set DNS host servers
     - ![DNS](assets/Screenshot%20from%202023-11-05%2009-21-41.png)
  2. we can use `nmcli` to set DNS host servers
     - `nmcli connection modify eth0 ipv4.dns 10.0.0.10` -> set the DNS server
  3. Alternatively we can use `/etc/NetworkManager/system-connections/` to set the DNS server

- If computer is configured to get the network configuration from DHCP server, then the DNS server will be automatically configured via DHCP
- If we don't want that to happen
  - we can add `PEERDNS=no` in the `/etc/sysconfig/network-scripts/ifcfg-eth0` file
  - `nmcli connection modify ens160 ipv4.ignore-auto-dns yes` -> set the DNS server

- `getent hosts <hostname>` -> shows the IP address of the hostname, it searches both /etc/hsots and DNS server
- `dig <hostname>` or `nslookup <hostname>` -> shows the IP address of the hostname, it searches only the DNS server

- we should not specify DNS servers directly in `/etc/resolv.conf` file, because it will be overwritten by NetworkManager