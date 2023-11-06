- [Configuring Networks](#configuring-networks)
  - [Fundamentals](#fundamentals)
  - [Managing Network Address and Interfaces](#managing-network-address-and-interfaces)
    - [Ports and services](#ports-and-services)
  - [Network configuration](#network-configuration)
  - [Setting up hostname and DNS](#setting-up-hostname-and-dns)
- [Software Management](#software-management)
- [Managing Processes](#managing-processes)
  - [Managing jobs](#managing-jobs)
  - [Managing Parent-child jobs](#managing-parent-child-jobs)
  - [Process Management](#process-management)
  - [Killing Processes](#killing-processes)
  - [Using Tuned to optmize performance](#using-tuned-to-optmize-performance)
- [Working with Systemd](#working-with-systemd)
  - [Unit Files](#unit-files)
    - [Understanding Unit Files](#understanding-unit-files)
    - [Understanding Mount Unit files](#understanding-mount-unit-files)
    - [Understanding Socket Unit files](#understanding-socket-unit-files)
    - [Understanding target Unit files](#understanding-target-unit-files)
      - [Systemctl](#systemctl)
- [Scheduling Jobs](#scheduling-jobs)
- [Configuring Logging](#configuring-logging)
  - [Role of rsyslogd and journald](#role-of-rsyslogd-and-journald)

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

# Software Management
**UNDER PROGRESS**

# Managing Processes
- **Shell Jobs**      -> processes that are started from the shell
- **Daemons**         -> processes that are started by the system
- **Kernel threads**  -> part of linux kernel, we can't manage them just for monitoring

- when a process starts it can use multiple threads, each thread has its own stack and registers
- so if a process is very busy, the threads will be handled by multiple CPU cores

- There are **Two** kinds of background processes
  1. `Kernel Threads`   -> part of linux kernel and each of them is started with it's own PID
     - `ps -ef | grep kthreadd` -> shows the kernel threads
     - Kernel threades aren't manageable, we can't assign a priority to them, neither we can kill them. Unless we reboot the system
  2. `Daemon processes` -> 

## Managing jobs
- all the jobs are processes as well, but not all the processes are jobs

- `jobs` -> shows the jobs running in the current shell
  - `&` -> runs the command in the background
  - `fg` -> brings the background job to foreground
  - `bg` -> runs the background job in the background
  - `Ctrl + Z` -> suspends the foreground job
  - `Ctrl + C` -> stops the current job and removes it from the memory
  - `Ctrl + D` -> job stops waiting for further input

- `ps` -> shows the processes running in the current shell

## Managing Parent-child jobs
- all processes started from a shell are terminated when that shell is stopped
- But processes started in the background will not be killed when the parent shell from which they were started is killed
- ![parent](assets/Screenshot%20from%202023-11-05%2013-36-08.png)
- if a parent process is killed while child process is still active it comes under **systemd** instead

## Process Management
- `ps` -> show process started by the current user
  - `ps -aux`     -> short summary of active processes
  - `ps -ef`      -> exact details of the command and processes started
  - `ps -fax`     -> parent child relationships between prcesses

- `top` -> shows processes in real time and a neat utility to manage processes

- By default all the processes are started with a default priority of **20**, but it can be altered using 
  - `nice`    -> start a process with adjusted priority
    - `nice -n 5 dd if=/dev/zero of=/dev/null`  -> starts with a default priority of 25
  - `renice`  -> change the priority of active process, `r` in top
    - `renice -n 10 -p 4845 `                   -> get's the process priority to 35
- we can select values ranging form `-20` to `19`, default niceness of a process is set to `0`. Which means `20`

## Killing Processes
- `kill` -> command used to kill process, or `k` with top utility
  - `kill -<signal> <pid>` -> kill the process using pid and signal

- There are signals that can be sent to a process all of them can be listed using `kill -l`
  - `SIGTERM` -> terminate the process    -> `15` -> default signal (recommended)
  - `SIGKILL` -> kill the process         -> `9`  -> uses force to stop the process (Risk of loss of data)
  - `SIGHUP`  -> hangup the process       -> `1`

- There are some commands that are related to kill,
  - `killall`     -> kill processes by name, if there are multiple processes by the same name
  - `pkill`       -> kill using pid

- `uptime` -> shows the uptime of the system
- `lscpu`  -> shows the details of the CPU

## Using Tuned to optmize performance
- `tuned` -> daemon that monitors the system and automatically tunes it for **optimal performance**
  - `yum -y install tuned` -> install tuned
  - `systemctl start tuned` -> start tuned service
  - `systemctl enable tuned` -> enable tuned service

- `tuned-adm`         -> command used to manage tuned profiles
- `tuned-adm list`    -> shows the list of profiles
- ![profiles](assets/Screenshot%20from%202023-11-05%2014-44-47.png)

- `tuned-adm active`    -> shows the active profile
- `tuned-adm recommend` -> recommends the best profile for the system
- **throughput-performance** is the one that allows maximum throughput

# Working with Systemd
- `systemd` -> system and service manager for linux, it is used to start **units**
- Units can be many things one of the most important unit types is the **service**
  - `systemctl -t help` -> provides **list of all the unit** types
- Services are proceses that provide specific functionality and allow connections from external devices

## Unit Files
- `/usr/lib/systemd/system` -> contains the unit files that are installed by the system
- `/etc/systemd/system`     -> contains custom unit files
- `/run/systemd/system`     -> contains the unit files that are created by the system (automatically)

- If units exisit in more than one directory them `/run/systemd/system` takes precedence over `/etc/systemd/system` and `/etc/systemd/system` takes precedence over `/usr/lib/systemd/system`
- Unit files are used to build the functionality that is needed on your server

### Understanding Unit Files
- ![atd.service](assets/Screenshot%20from%202023-11-05%2018-49-54.png)
- `[UNIT]`
  - has description of the unit and the dependencies (what should be started **before** this unit and **after** this unit)
  - Dependencies can also be defined using keywords like **Requires**, **Requisite**, **Wants** etc
- `[SERVICE]`
  - describes how to start and stop the service
  - **ExecStart** line which contains the command to start the service
  - **ExecStop** line which contains the command to stop the service
- `[INSTALL]`
  - describes in which **target** the unit has to be started
  - for example **multi-user.target** is one of the targets

- `systemctl show <unit>` -> gives available options that can be configured for the unit
- all the edited unit files should be reloaded using `systemctl daemon-reload` command
  - we can edit the files directly using text editor or we can use `systemctl edit <unit>` command
- edited files go into `/etc/systemd/system` directory

### Understanding Mount Unit files
- ![dev-mqueue.mount](assets/Screenshot%20from%202023-11-05%2018-55-23.png)
- `[MOUNT]`
  - describes where the mount point is and what to mount

### Understanding Socket Unit files
- ![sshd.socket](assets/Screenshot%20from%202023-11-05%2018-58-01.png)
- `[SOCKET]`
  - the ListenStream defines on which port is the service listening

### Understanding target Unit files
- ![multi-user.target](assets/Screenshot%20from%202023-11-05%2018-59-41.png)
- a target unit is a group of units that are started together
- targets themselves have dependencies on other targets these are defined inside a target unit
  - `systemctl list-dependecies` -> shows the dependencies of the target, by default it shows `default.target`

- For instance we made `vsftpd.service` to start at boot using `systemctl enable vstpd.service`
  1. a sysmbolic link is created in `/etc/systemd/system/multi-user.target.wants/vstpd.service` pointing to `/usr/lib/systemd/system/vstpd.service` 
  2. hence ensuring that the service is started at boot
  3. this symbolic links is called as `want`

#### Systemctl 
- Managing systemd units starts with starting and stopping units, which is done through `systemctl`
  - `systemctl start <unit>`    -> starts the unit
  - `systemctl stop <unit>`     -> stops the unit
  - `systemctl restart <unit>`  -> restarts the unit
  - `systemctl reload <unit>`   -> reloads the unit
  - `systemctl status <unit>`   -> shows the status of the unit
  - `systemctl enable <unit>`   -> enables the unit to start at boot

- `systemctl --type=service`                -> shows all the services
- `systemctl list-units --type=service`     -> shows all the active service units
- `systemctl --failed --type=service`       -> shows all failed services
- `systemctl status -l <unit>`              -> shows the status of the unit in detail

# Scheduling Jobs
**UNDER PROGRESS**

# Configuring Logging
- **Direct Write**  -> logs are written directly to the log files
- **rsyslogd**      -> enhacement of **syslogd**, a service that takes care of managing centralized log files
- **journald**      -> this is tightly integrated with systemd, which allows admin to read from journal while monitoring the system

## Role of rsyslogd and journald
**Under Progress**

