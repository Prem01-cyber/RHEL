Ensure firewalld and SELinux enables and your server should survive boot

Configure the network
Assign hostname and IP addresses for virtual machines as per the following table:
Hostname        - system1.eight.example.com
IP address      - 192.168.55.150
Netmask         - 255.255.255.0    


- hostnamectl set-hostname system1.eight.example.com
- nmcli connection modify ens33 ipv4.addresses 192.168.55.150/24 ipv4.gateway 192.168.55.1 ipv4.dns 8.8.8.8 ipv4.method static
- nmcli connection up "System ens33"


Configure the repositories which are available on reposerver at:
http://repo.eight.example.com/BaseOS
http://repo.eight.example.com/AppStream


- /etc/yum.repos.d/local.repo 
  - [AppStream]
  - name=AppSream
  - baseurl=http://repo.eight.example.com/AppStream
  - enabled=1
  - gpgcheck=0
- /etc/yum.repos.d/local.repo 
  - [BaseOS]
  - name=BaseOS
  - baseurl=http://repo.eight.example.com/BaseOS
  - enabled=1
  - gpgcheck=0


Configure the SELinux:
Your web content has been configured in port 82 at the /var/www/html directory (Don't alter or remove any files in this direcotory) make the content accessible


- yum install httpd -y
- yum install httpd vstpd -y
- systemctl start httpd
- systemctl enable --now httpd
- yum install -y policycoreutils*
- semanage port -a -t http_port_t -p tcp 82
- semange port -l | grep http_port_t
- firewall-cmd --permanent --add-port=82/tcp
- firewall-cmd --reload
- firewall-cmd --list-all
- vim /etc/httpd/conf/httpd.conf
  - `<virtualhost 192.168.55150:82>`
  - servername system1.eight.example.com
  - documentroot /var/www/html
  - `</virtualhost>`
  - Listen 82
- systemctl restart httpd


Create the following users, groups and group memberships;
(a) A group named admin
(b) A user harry who belongs to admin as a secondary group
(c) A user natasha who belongs to admin as a secondary group
(d) A user sarah who does not have access to an interactive shell on the system and who is not a member of admin group
(e) The users harry, natasha, sarah should all have the password password


- grouadd admin
- useradd harry -G admin
- useradd natasha -G admin
- useradd sarah
- chsh sarah -s /sbin/nologin
- passwd harry > password
- passwd natasha > password
- passwd sarah > password


Create a collaborative directory /common/admin with the following chracteristics:
(a) Group ownership of /common/admin is admin
(b) The directory should be readable, writable and accessible to members of admin, but not any other user. (It is understood that root access to all files and directories on the system)
(c) Files created in /common/admin automatically have group ownership set to the admin group

- mkdir -p /common/admin
- chown :admin /common/admin
- chmod 770 /common/admin
- chmod g+s /common/admin

Configure Autofs:
(a) to automatically mount the below NFS shares on system1.eight.example.com machine at /automount directory
192.168.55.151:/public and 192.168.55.151:/private
(b) the public nfs share should have read only access for all users
(c) the private nfs share should have read write access for all users
(d) both shares should get automatically unmounted if not in use for 30 seconds


- yum install nfs-utils nfs4-acl-tools autofs -y
- mkdir -p /automount/public /automount/private
- systemctl enable --now autofs
- vim /etc/auto.master
  - /automount /etc/automount.txt --timeout=30
- vim /etc/automount.txt
  - public -ro,sync 192.168.55.151:/public
  - private -rw,sync 192.168.55.151:/private
- systemctl restart autofs
- showmount -e 192.168.55.151



(a) Set a cron job for harry on 12:30 at noon print "hello" using echo command
(b) deny the natasha user to create a cronjob in system


- crontab -e -u harry
  - 30 12 * * * echo "hello"
- vim /etc/cron.deny
  - natasha
- crontab -lu harry


Configure ACL Permissions:
Copy the file /etc/fstab to /var/tmp. Configure the permission of /var/tmp/fstab so that:
(a) the file /var/tmp/fstab is owned by root user
(b) the file /var/tmp/fstab belongs to the group root
(c) the file /var/tmp/fstab should bot be executable by anyone
(d) the user harry is able toread and write by /var/tmp/fstab
(e) the user harry is able to read and write by /var/tmp/fstab
(f) all the other users (current/future) have the ability to read /var/tmp/fstab


- cp /etc/fstab /var/tmp
- chown root:root /var/tmp/fstab
- chmod 644 /var/tmp/fstab
- setfacl -m u:harry:rw /var/tmp/fstab
- setfacl -m u:natasha:--- /var/tmp/fstab
- setfacel -m o::r /var/tmp/fstab
- getfacel /var/tmp/fstab



Configure the NTP:
(a) Configure your system so that it is an NTP client of system2.eight.example.com(192.168.55.151)


- yum install chrony -y
- vim /etc/chrony.conf
  - server 192.168.55.151 iburst
- systemctl enable --now chronyd
- systemctl restart chronyd
- chronyc sources



Locate and copy files
Find all the files that greeater than 4 MB in the /etc directory and copy them to /find/largefiles directory


- find / -type f -size +4M -exec cp {} /find/largefiles \;


(a) Create a new user with UID 1326, username and password as alies
(b) Create an archive fle:
Backup the /var/tmp as /root/test.tar.gz
(c) set the permissions
    - All new creatng for natasha as -r-------- (read only) as default permission
    - All new creating directories for user natasha as dr-x------- as default permission


- useradd -u 1326 alies
- passwd alies
  - alies
- tar -cvzf /root/test.tar.gz /var/tmp
- setfacl -m u:natasha:r /var/tmp
- setfacl -m d:u:natasha:rx /var/tmp



(a) The password for all new users in system1.eight.example.com should expires after 20days
(b) assign sudo privilege for group "admin" and Group members can administrate without any password


- vim /etc/login.defs
  - PASS_MAX_DAYS 20
- visudo
  - %admin ALL=(ALL) NOPASSWD: ALL


- chage -l alies
- vim /etc/sudoers.do/10_admin
  - %admin ALL=(ALL) NOPASSWD: ALL



Create a bash shell script program for:
(a) Create a mysearch script to locate file under /usr/share having size less than 1M
(b) After executing the mysearch script file and listed (searched) files has to be copied under /root/myfiles directory


- vim mysearch
  - !#/bin/bash
  - find /usr/share -type f -size -1M -exec cp {} /root/myfiles \;


Reset the forgotten root password ins system2.eight.example.com and set it as redhat



- reboot
- e
- rescue.target
- rd.break
  - remove rhgb and quiet
- we go into maintainence mode
- mount -o remount,rw /sysroot
- chroot /sysroot
- passwd
  - redhat
- touch /.autorelabel
- exit
- exit


(a) Create a swap partition 512MB size
(b) Create one logical volume named database and it should be on datastore volume group with 50 extent and assign the filesysem ext3 the datastore volume group extend should be 8Mib (Mount lofical volume under mount point /mnt/database)


- lsblk
- fdisk /dev/sdb
- n -> new partition
- p -> primary
- 1 -> partition number
- +512M -> size
- t -> type
- 82 -> swap
- w  -> write
- partprobe
- mkswap /dev/sdb1
- swapon /dev/sdb1
- lsblk
- vim /etc/fstab
  - /dev/sdb1 swap swap defaults 0 0
- free -h


- fdisk /dev/sdb
- n -> new partition
- p -> primary
- 2 -> partition number
- +2G -> size
- t -> type
- 8e -> LVM
- w  -> write
- partprobe
- pvcreate /dev/sdb2
- vgcreate -s 8M datastore /dev/sdb2
- lvcreate -l 50 -n database datastore
- lvdisplay
- mkfs.ext3 /dev/datastore/database
- lsblk
- mkdir /mnt/database
- vim /etc/fstab
  - /dev/datastore/database /mnt/database ext3 defaults 0 0
- mount -a



Create the vectra volume using the VDO with logical size 50GB and mount under test dierctory


- yum install vdo kmod-kvdo -y
- systemctl enable --now vdo
- wipefs -a /dev/sdb2
- vdo create --name=vectra --device=/dev/sdb2 --vdoLogicalSize=50G
- vdo list
- mkfs.xfs /dev/mapper/vectra
- mkdir /test
- mount /dev/mapper/vectra /test
- vim /etc/fstab
  - /dev/mapper/vectra /test xfs defaults,x-systemd.requires=vdo.service,discard 0 0
- mount -a
- df -hT
- vdostats --human-readable



Resize the logical volume size of +100 extents on /mnt/database directory

- lvdisplay
- lvs
- lvextend -l 100 -r /dev/datastore/database
- lvs


set the recommended tuned profile for your system


- yum install tuned -y
- systemctl start tuned
- systemctl enable --now tuned
- tuned-adm profile
- tuned-adm recommend
- tuned-adm profile virtual-guest
- systemctl restart tuned
- tuned-adm active


Create the container as a system startup service
(a) Create the container name as logserver with the images rsyslog are stored in docker on paradise user
(b) the containr should be configured as a system startup services
(c) the container directory is container_journal should be created on pardise user.


- we need two terminals user and root
- need to perform rootless container
- ssh paradise@192.168.106.55 (normal user)
- in rhel 8 we need to install container management tools, but in rhel 9 we don't need to install container management tools


- root user
  1. ls /var/log
  2. ls /run/log/journal
  3. vim /etc/systemd/journald.conf 
    - [Journal]
    - Storage=persistent
  4. systemctl restart systemd-journald
  5. journalctl -xe
    -  path similar to /run/log/journal/xxxxxxx
  7. cp -rvf /run/log/journal/xxxxxxx/system.journal /home/paradise/container_journal
  28. reboot
  29. podman ps

- pardise user
  6. mkdir ~/container_journal
  8. podman login `<registry name>` 
  9. podman search rsyslog
  10. podman pull `<image name>`
  11. podman images
  12. podman run -d --name logserver -v /home/paradise/container_journal:/var/log/journal:Z `<image name>`
  13. podman ps
  14. mkdir -p ~/.config/systemd/user
  15. podman generate systemd --name logserver > ~/.config/systemd/user/logserver.service --new
  16. cat ~/.config/systemd/user/logserver.service
  17. podman stop logserver
  18. podman rm logserver
  19. podman ps
  20. loginctl show-user paradise
  21. loginctl enable-linger paradise
  22. loginctl show-user paradise
  23. systemctl --user daemon-reload

- if we get an error regarding XDG_RUNTIME_DIR
  24. echo $XDG_RUNTIME_DIR
      1.  /run/user/1000
  25. export XDG_RUNTIME_DIR=/run/user/(id -u)

  26. systemctl --user enable container-logserver.service --now
  27. podman ps
  30. cd /home/paradise/container_journal
  31. ls -> system.journal


Configure the containeras persistent storage and create logs for container
(a) Configure the container with persistent storage that mounted on /var/log/journal to /home/paradise/container
(b) The container directory contains all the journal files

