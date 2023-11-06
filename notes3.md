- [Managing Apache and HTTP Services](#managing-apache-and-http-services)
  - [Installing Required Software](#installing-required-software)
  - [Creating web server content](#creating-web-server-content)
  - [Apache Configuration files](#apache-configuration-files)
  - [Creating Apache Virtual hosts](#creating-apache-virtual-hosts)
- [Managing SELinux - Security Enhanced Linux](#managing-selinux---security-enhanced-linux)
  - [Understanding Context Settings and Policy](#understanding-context-settings-and-policy)
  - [Setting Context types](#setting-context-types)
  - [Using boolean settings to modify SELinux Settings](#using-boolean-settings-to-modify-selinux-settings)
  - [Exam conditions](#exam-conditions)
- [Linux Firewalling](#linux-firewalling)
  - [Understanding Firewalld service](#understanding-firewalld-service)
- [Accessing Network Storage](#accessing-network-storage)
  - [Mounting NFS share](#mounting-nfs-share)
  - [Using CIFS services](#using-cifs-services)
  - [Configuring Samba Server](#configuring-samba-server)
  - [Mounting remote file system using fstab](#mounting-remote-file-system-using-fstab)
  - [Configuring automount](#configuring-automount)


# Managing Apache and HTTP Services
- Apache is the most popular web server on the internet it requires httpd package to be installed
- Apache uses port 80 by default
- Apache configuration files are located in **/etc/httpd/conf/httpd.conf**
- the most important parameter in the configuration file is **DocumentRoot**, which defines the default location where apache will look for its **contents**
  - Apache uses **/var/www/html** as the default DocumentRoot
- another important parameter in the configuration file is **ServerRoot**, which defines the default directory where apache will look for its **configuration files**
  - the default location for ServerRoot is **/etc/httpd**

## Installing Required Software
- `yum search httpd`            -> to search for httpd packages
- `yum module install httpd`    -> to install httpd base package and additional modules

- `systemctl status httpd`      -> to check the status of httpd service
- `systemctl start httpd`       -> to start httpd service

## Creating web server content
- `mkdir /var/www/html/test`    -> to create a directory for test at the location of DocumentRoot

## Apache Configuration files
- a default installation of apache server create a tree in `/etc/httpd` directory
- ![apache tree](assets/Screenshot%20from%202023-11-06%2000-29-44.png)

- the symbolic links to **logs, modules, run and state** are created to create a `chroot environment` for apache
  - chroot environment is a way to isolate a process and its children from the rest of the system
  - chroot provides a fake root directory

- the **conf** directory contains the main configuration file **httpd.conf** and other configuration files
- the **conf.d** directory contains files that are included in the apache configuration
  - files added by line `IncludeOptional conf.d/*.conf` in **httpd.conf** file
- the **conf.modules.d** directory contains modules and as apache is a modular server the functionality can be extended by adding modules to it.

## Creating Apache Virtual hosts
- **CURRENTLY NOT IN RHCSA**

# Managing SELinux - Security Enhanced Linux
- SELinux provides mandatory access control to a linux server, where every system call is denied unless it has been specifically allowed
- SELinux is a kernel module that is loaded at boot time

- if SELinux is enabled and nothing else is configured all the system calls are denied
- To specify what is allowed and what is denied we use **SELinux policies**
- Changing between SELinux enabled and disabled required reboot
  - To set the default SELinux mode while booting use the file `/etc/sysconfig/selinux`
- If SELinux is enabled you can select to put SELinux in **permissive mode** which will log all `the denied system calls but will not deny them
  - The log messages are written to `/var/log/audit/audit.log`
  - SELinux messages are logged with `type=AVC` in the audit.log file
  - `grep AVC /var/log/audit/audit.log` -> to check the SELinux messages
  - Reading logs might be hard but looking close we can pretty much analyse the logs
  - alternatively we have `sealert` which can help with analyzing the logs
    - `yum -y install setroubleshoot-server` -> to install **sealert**
  - `sealert -a /var/log/audit/audit.log` -> to analyze the logs
- In **enforcing mode** SELinux will deny all the system calls that are not allowed, which is based on the SELinux policies
- Keeping SELinux in **disabled mode** makes the system vulnerable to attacks

- `getenforce` -> to check the current SELinux mode
- `setenforce` -> to set the SELinux mode temporarily
  - `setenforce 0` -> to set SELinux to permissive mode
  - `setenforce 1` -> to set SELinux to enforcing mode
  - To make the changes permanent we need to edit the file `/etc/sysconfig/selinux`
- `sestatus` -> to check the current SELinux status
  - `sestatus -v` -> to check the current SELinux status in verbose mode

## Understanding Context Settings and Policy
- SELinux uses **contexts** to determine what is allowed and what is denied, these are kind of like labels and are applied to
  - Files and directories
  - Ports
  - Processes
  - Users

- Context labels define the nature of the object and SELinux rules are created to match context labels of **source objects** to context labels of **target objects**
- ![SELinux Contexts](assets/Screenshot%20from%202023-11-06%2010-23-33.png)
- `ls -Z` -> to check the context labels of files and directories
- `ps -Z` -> to check the context labels of processes

- Every context label consists of three different parts
  - **user** -> the SELinux user that the object belongs to
  - **role** -> the SELinux role that the object belongs to
  - **type** -> the SELinux type that the object belongs to

## Setting Context types
- We can use two commands to set context types
  - `semange` (Recommended)     -> writes new context to SELinux policy from which it is applied to the file system
  - `chcon`   (don't use it)    -> changes the context of the file system without writing it to SELinux policy

- before setting a new context we need to what is an appropriate context for the object
- ![SELinux Contexts](assets/Screenshot%20from%202023-11-06%2010-34-01.png)
- - `semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"` -> to add a new context to SELinux policy
  - `-a` -> to add a new context
  - `-t` -> to specify the type of the context
  - `"/var/www/html(/.*)?"` -> is a regular expression that matches all the files and directories in the `/var/www/html` directory
- as we used semange it writes the new to SELinux policy now to complete it
  - `restorecon -R -v /mydir` -> to restore the context of the directory based on SELinux policy  


- Roughly there are **3** approaches to know the context 
  - look at the context of a similar object (Default Environment)
  - Read the configuration files
  - use `man -k _selinux` to search for SELinux related commands (Recommended)
    - On RHEL these are not installed by default
    - we need to install using `yum install -y policycoreutils-devel`
    - after which we can use `sepolicy manpage -a -p /usr/share/man/man8` to install SElinux man pages

- ![One](assets/Screenshot%20from%202023-11-06%2010-49-49.png)
- ![Two](assets/Screenshot%20from%202023-11-06%2010-50-52.png)
- ![Three](assets/Screenshot%20from%202023-11-06%2011-16-18.png)
- ![Four](assets/Screenshot%20from%202023-11-06%2011-16-42.png)

- if a new file is **created** it inheritst the context setting of **parent directory**
- If a file is **copied** to a directory, it also inherits the settings of **parent directory** as it is considered as a new file
- if a file is moved or copied to a new location with (`cp -a`) the original context settings are **preserved**
- if we don't want the newer contexts we can always use `restorecon` to resotore context or we can create a file name `.autorelabel` in the root directory and reboot the system. 
- Once the system reboots it will relabel all of them based of SELinux policies and then delete the `.autorelabel` file
- ![restorecon](assets/Screenshot%20from%202023-11-06%2011-27-58.png)

## Using boolean settings to modify SELinux Settings
- changing rules is not easy and that is why we have **boolean settings** which are used to modify SELinux settings
- `getsebool -a` or `semange boolean -l` -> to list all the boolean settings
  - `setsebool -P httpd_can_network_connect 1` -> to set the boolean setting permanently

- ![boolean settings](assets/Screenshot%20from%202023-11-06%2011-32-28.png)

## Exam conditions
- make sure to check SELinux is enabled and in enforcing mode by editing `/etc/sysconfig/selinux`
- use `restorecon` to reapply the right context to file or directory
- use `sealert` to analyze the logs

# Linux Firewalling
- firewall is implemented in the kernel using **netfilter (nftables)** (newer) and **iptables** (older)
- `firewalld` is a system service that can configure firewall rules by using different interfaces
  - we use `firewall-cmd` command to interact with `firewalld`
- applications can request ports to be opened by using **DBus** messaging system
  - which means rules can be added or removed without any direct action from administrator
- `firewalld` uses **zones** to group interfaces and services
  - a **zone** is a set of rules that are applied to incoming traffic
- Firewalld applies to incoming packets only by default and no filtering happens on outgoing packets

## Understanding Firewalld service
- Serivice in firewalld is not the same as a service in systemd
- Firewalld service specifies what exactly should be accepted and what should be rejected
- it includes port opened and modules loaded 
  - `firewall-cmd --get-services` -> to list all the services available on your system
  - `firewall-cmd --get-zones` -> to list all the zones available on your system
- The right services must be added to the right zones
  - BTS every service is an XML (RPM Installed) file located at `/usr/lib/firewalld/services`
  - `firewall-cmd --zone=public --add-service=http` -> to add http service to public zone, adds it **temporarily** - runtime configuration
  - `firewall-cmd --zone=public --add-service=http --permanent` -> to add http service to public zone **permanently**
  - Custom services can be added to `/etc/firewalld/services` directory and will be automatically picked up upon restart

# Accessing Network Storage
- **NFS** is a protocol that allows us to share directories and files over the network
- **NFS4** is the current version in RHEL
- we can use `mount` utility to nfs shares
  - we can specify version using `nfsvers` option

- Setting up nfs
  1. Create a local directory
  2. edit the `/etc/exports` file to specify the directory to be shared
  3. start NFS server
  4. configure your firewall to allow NFS traffic

- ![Exercise 24-1](assets/Screenshot%20from%202023-11-06%2013-52-09.png)

## Mounting NFS share
- We need to know the mounts name in order to mount it
  - we can be assisted by the administrator of the NFS server
  - `showmount -e server2.example.com` -> to list all the mounts

- `mount server2.example.com:/ /mnt` -> to mount the root directory of the server2.example.com to /mnt
  - we can check the mount using `mount` command or we can verify by going to `/mnt` directory
  - `mount -t nfs -o nfsvers=4 server2.example.com:/ /mnt` -> to mount the root directory of the server2.example.com to /mnt using NFS4

## Using CIFS services
- **SMB** protocol is foundation of all shares that are created in a windows enviroment
- a samba become more standardized it is now called **CIFS** (Common Internet File System)

- Before mounting a CIFS share we need to install `cifs-utils` package
  - `yum install -y cifs-utils`
- we can use `smbclient -L server2.example.com` to list all the shares available on the server2.example.com
- Now we can mount the smb shares using mount command
  - `mount -t cifs -o username=administrator,password=redhat //server2.example.com/share /mnt` -> to mount the share to /mnt

## Configuring Samba Server
**NOT FOR RHCSA**

## Mounting remote file system using fstab
- we can mount manually mount NFS and CIFS shares but it is not a good practice
- we can use `/etc/fstab` file to mount the shares automatically at boot time
- ![fstab](assets/Screenshot%20from%202023-11-06%2015-26-37.png)
  - `server2.example.com:/share /mnt nfs sync 0 0`
  - server2.example.com:/share  -> is the remote share
  - /mnt                        -> is the local mount point
  - nfs                         -> is the file system type
  - sync                        -> is the mount option
  - 0 0                         -> are the dump (No backup support throught `dump` utility) and fsck (don't check the integrity) options

- for samba shares
  - `//server2.example.com/share /mnt cifs username=administrator,password=redhat 0 0`

## Configuring automount
- alternatively we configure automount to mount the share automatically
- **automount** is implemented using **autofs** service and automount ensures that the **share is mounted only when it is accessed**
- the important benefit of using automount is that it works completely in user space and does not require sudo permissions like mount

- to configure automount we need to edit `/etc/auto.master` file
  - `/nfsdata /etc/auto.nfsdata` -> edit in `/etc/auto.master` file
  - `files -rw server2:/nfsdata` -> edit in `/etc/auto.nfsdata` file
    - files             -> name of the subdirectory that will be created in the mount point as a relative file name
    - -rw               -> is the mount option
    - server2:/nfsdata  -> is the remote share

- In some cases we use wildcards while mounting files
  - `* -rw server2:/users/&` -> to mount all the files in the `/users` directory of the server2
    - the `&` is replaced by the name of the file
    - the files will be mounted as `/users/file1`, `/users/file2` and so on