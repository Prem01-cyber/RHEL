- [Managing Apache and HTTP Services](#managing-apache-and-http-services)
  - [Installing Required Software](#installing-required-software)
  - [Creating web server content](#creating-web-server-content)
  - [Apache Configuration files](#apache-configuration-files)
  - [Creating Apache Virtual hosts](#creating-apache-virtual-hosts)


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