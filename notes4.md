- [Managing Software Packages with yum](#managing-software-packages-with-yum)
  - [Specifying which repository to use](#specifying-which-repository-to-use)
  - [Managing software with rpm](#managing-software-with-rpm)
- [Managing Storage](#managing-storage)
  - [Managing Partitions and file systems](#managing-partitions-and-file-systems)
  - [Creating file sytems](#creating-file-sytems)
  - [Adding swap partitions](#adding-swap-partitions)
  - [Mounting file systems](#mounting-file-systems)
- [Managing Advanced storage](#managing-advanced-storage)
  - [Logical Volume Manager](#logical-volume-manager)
    - [Creating LVM Logical Volumes](#creating-lvm-logical-volumes)
    - [Resizing LVM Logical volumes](#resizing-lvm-logical-volumes)
  - [Configuring Stratis](#configuring-stratis)
    - [Understanding Stratis Architecture](#understanding-stratis-architecture)
  - [Creating Stratis Storage](#creating-stratis-storage)
    - [Managing Stratis](#managing-stratis)
  - [Configuring VDO](#configuring-vdo)
    - [Setting up VDO](#setting-up-vdo)

# Managing Software Packages with yum
- To separate core os packages from user-space packages RHEL provides two main repositories
  - **BaseOS**   -> contains the core os packages as **rpm packages**
  - **AppStream**-> contains the user-space packages, traditional **rpm packages** and **modules**

- modules are set of rpm packages together
  - `yum module list` -> list all the modules that are available to our system
  - each module has one or more **streams**
    - a stream contains one specific version and updates are provided for that stream
  - modules also have one or more **profiles**
    - a profile is a list of rpm packages that are installed together for a particular use case

- we can **Subscription Manger** to register our system with Red Hat Network
  - `subscription-manager register --username=<username> --password=<password>`
  - By which we can get access to the Red Hat Network which contains an inventory of software packages that we can install on our system
  - `susbcription-manager list --available`         -> list all the available software packages
  - `subscription-manager attach --pool=<pool_id>`  -> attach a pool to our system
  - `subscription-manager --consumed`               -> subscriptions we are currently using

- after registration the certificates are written `/etc/pki/` directory
  - `/etc/pki/consumer`     -> contains the consumer certificates
  - `/etc/pki/entitlement`  -> contains the information about the subscriptions that are attached to the system

## Specifying which repository to use
- `yum repolist` -> list all the repositories that are available to our system
- if you want to install a package from a specific repository
  - `yum install --disablerepo=* --enablerepo=<repo_name> <package_name>`
  - `yum install --disablerepo=* --enablerepo=rhel-7-server-optional-rpms <package_name>`

- To tell server which repository to use you need to create a file in `/etc/yum.repos.d/` directory with a `.repo` extension
- ![yum_repo](assets/Screenshot%20from%202023-11-07%2000-50-25.png)
  - **[label]**     -> name of the repository
  - **baseurl**     -> url that points to specific repository (Most Important)
  - **enabled**     -> whether the repository is enabled or not
  - **gpgcheck**    -> to check the integrity of the repository at the time of boot
  - **name**        -> name of the repository

- When using a repository where GPG package signing has been used on first contact with the repository
- the `rpm` command will propose to download and install the key that was used for package signing
  - the **gpgkey** that were used for package sighning are isntalled tot he `/etc/pki/rpm-gpg/` directory

- `yum clean all` -> clean the cache of the yum
- `yum repolist`  -> list all the repositories that are available to our system
- `yum search <package_name>` -> search for a package
- `yum info <package_name>`   -> get information about a package
- `yum install <package_name>` -> install a package
- `yum remove <package_name>`  -> remove a package
- `yum update <package_name>`  -> update a package
- `yum list installed`         -> list all the installed packages
- `yum provides */<package_name>` -> find out which package provides a specific file

## Managing software with rpm
- while installing packages with `rpm` we need to make sure that all the dependencies are met else it's a **Dependency hell**
- `autofs-5.0.7-83.el7.x86_64.rpm` -> name of the rpm package
  - `autofs` -> name of the package
  - `5.0.7`  -> version of the package
  - `83`     -> release of the package
  - `el7`    -> operating system
  - `x86_64` -> architecture

- rpm packages are installed in `/var/lib/rpm/` directory
- RPM queries by default use **RPM Database**
- rpm packages enables you to get much information about packages, using it might allow us to find out how software can be configured and used
  - `rpm -qa` or `yum list installed`   -> list all the packages that are installed on the system
  - `rpm -qi <package name>`              -> get information about a package
  - `rpm -ql <package name>`              -> list all the files that are installed by a package
  - `rpm -qd <package name>`              -> list all the documentation files that are installed by a package
  - `rpm -qc <package name>`              -> list all the configuration files that are installed by a package
  - `rpm -qf <file name>`                 -> find out which package a file belongs to
  - `rpm -qpR <package name>`             -> list all the dependencies of a package

- there is a slight problem with `rpm -qp` command
  - it works only on RPM package files and it can't query files directly from the repositories
  - if you want to query repositories before they have been installed you need to use `repoquery` command
    - `yum install yum-utils` -> install `yum-utils` package
    - `repoquery -qf <file name>` -> find out which package a file belongs to


# Managing Storage
- `lsblk` -> list all the block devices that are available to our system
- `df -h` -> list all the file systems that are available to our system

- to use a hard disk we need to create a **partition** on it
- To create a partition there are two schemes
  - **MBR** -> Master Boot Record
    - 512 bytes
    - Contains GRUB2 and Partition Table
    - No more than 4 primary partitions
      - one primary partition can be an extended partition
    - Maximum size of 2TB
    - Single point of failure
  - **GPT** -> GUID Partition Table
    - 8Zib (Zebibyte) = 1024 Exbibyte
    - Contains GRUB2 and Partition Table
    - No more than 128 partitions
    - The 2TB limit does not apply
    - uses **UEFI** instead of **BIOS**
    - uses 128-bit GUID to identify partitions
    - Backup of GPT is stored at the end of the disk

- Boot process of MBR 
  - while booting **BIOS** is loaded to access hardware
  - from BIOS **Bootable** disk was loaded
  - from **Bootable** disk **MBR** was loaded
  - **MBR** contains **Partition Table** and **Boot Loader**
    - **Partition Table** contains information about the partitions
    - **Boot Loader** loads the **Kernel** into memory
  - **Kernel** loads the **Initramfs** into memory
  - **Initramfs** loads the **Init** process
  - **Init** process loads the whole OS

## Managing Partitions and file systems
- There are 2 different partition utilities available in RHEL
  - `fdisk`     -> used to create partitions on **MBR** disks
  - `gdisk`     -> used to create partitions on **GPT** disks
  - `parted`    -> used to create partitions on both **MBR** and **GPT** disks

- creating MBR partitions using fdisk
  - `fdisk <device_name>` -> start fdisk utility
    - `n` -> create a new partition
    - `p` -> primary partition
    - `e` -> extended partition
    - `l` -> list all the partitions
    - `d` -> delete a partition
    - `w` -> write the changes to the disk
    - `q` -> quit fdisk utility
  - `fdisk -l` -> list all the partitions that are available to our system
  - partitions will be added to the partition table but inorder to update kernel partition table we need to use `partprobe` command
    - `partprobe <device_name>` -> update kernel partition table
  - if `partprobe` causes errors just reboot the system

- we always need to use same partition utility everytime we do partitions else the system would not restart

- creating GPT partitions using gdisk
  - `gdisk <device_name>` -> start gdisk utility
    - `n` -> create a new partition
    - `p` -> primary partition
    - `e` -> extended partition
    - `l` -> list all the partitions
    - `d` -> delete a partition
    - `w` -> write the changes to the disk
    - `q` -> quit gdisk utility

- creating partitions with parted
- parted lacks some advanced features so it's better to stick with fdisk and gdisk
  - `parted <device_name>` -> start parted utility
    - `mklabel <label_type>` -> create a partition table
    - `mkpart <part_type> <fs_type> <start> <end>` -> create a partition
    - `print` -> list all the partitions
    - `rm <part_num>` -> delete a partition
    - `quit` -> quit parted utility

## Creating file sytems
- a partition by itself is not useful, it is only useful if you decide to do something with it
- we need to put a **filesystem** on top of it
- default filesystem in RHEL is **XFS**, previously it was **EXT4**

- to format a partition we need to use `mkfs` command
  - `mkfs -t <fs_type> <device_name>` -> format a partition
  - `mkfs.xfs <device_name>` -> format a partition with XFS filesystem
  - `mkfs.ext4 <device_name>` -> format a partition with EXT4 filesystem

- we can also change properties of a file using `tune2fs` command
- it is developed for **EXT2** and **EXT3** filesystems but it also works with **EXT4** filesystems
  - `tune2fs -l <device_name>` -> list all the properties of a filesystem
  - `tune2fs -L <label> <device_name>` -> change the label of a filesystem
  - `tune2fs -c <count> <device_name>` -> change the maximum mount count of a filesystem
  - `tune2fs -i <interval> <device_name>` -> change the maximum mount interval of a filesystem
  - `tuen2fs -o <option> <device_name>` -> to set default system mount options
    - `tune2fs -o ^acl <device_name>` -> enable ACLs on a filesystem, ^ is used to toggle the feature
  - `tune2fs -O ` -> switch on fiel system feature

- we can also change properties of a file using `xfs_admin` command
- it is specifically developed for **XFS** file system
  - `xfs_admin -l <device_name>` -> list all the properties of a filesystem
  - `xfs_admin -L <label> <device_name>` -> change the label of a filesystem

## Adding swap partitions
- swap partitions are used to store data that is not used by the system they are generally located on disk device
- `free -m` -> list all the memory that is available to our system (swap space)
- it is used for better performance of memory
- sometimes allocating more swap space than the amount of RAM is also a good idea
- we can create additional swap using `fdisk` or `gdisk` just by specifying the partition type as **Linux Swap**
  - then we use `mkswap` command to format the partition as swap partition
    - `mkswap <device_name>` -> format a partition as swap partition
  - then we use `swapon` command to enable the swap partition
    - `swapon <device_name>` -> enable the swap partition

- we can also create a swap file instead of swap partition
  - `dd if=/dev/zero of=/swapfile bs=1M count=1024` -> create a swap file of 1GB
  - `mkswap /swapfile` -> format the swap file
  - `swapon /swapfile` -> enable the swap file
    - `echo "/swapfile swap swap defaults 0 0" >> /etc/fstab` -> add the swap file to the fstab file so that it will be enabled at boot time

## Mounting file systems
- we can use `mount` command to mount files and `umount` command to unmount the files
- if we want to make the mounts persistant we edit the `/etc/fstab` file accourdingly on reboot the file systems will be mounted automatically  
  - `mount -a` -> mount all the file systems that are listed in the `/etc/fstab` file
  - `mount -t <fs_type> <device_name> <mount_point>` -> mount a file system
  - `umount <mount_point>` -> unmount a file system
  - `umount -a` -> unmount all the file systems that are listed in the `/etc/fstab` file

- we can also make use of **UUID** or **Disk Labels** to mount the file systems
  - `blkid` -> list all the block devices that are available to our system
    - `mount UUID=<uuid> <mount_point>` -> mount a file system using UUID
  - `mount label=<label> <mount_point>` -> mount a file system using Disk Label

- while specifying the mount options there are wide variety of options
- the most preferred option is `defaults` which is equivalent to `rw, suid, dev, exec, auto, nouser, async`
  - `defaults` -> use default mount options
  - `noauto` -> don't mount the file system automatically
  - `noexec` -> don't allow execution of binaries on the file system
  - `nodev` -> don't allow creation of device files on the file system

# Managing Advanced storage
- disks aren't flexible enough to meet the needs of modern applications, hence LVM is introduced

## Logical Volume Manager
- These can be anything
- the storage devices need to flagged as physical volumes which makes then usable by LVM
- the actual file systems are created on logical volumes, which makes them flexible
  - in order to resize the file systems when logical volumes are resized the files must offer support for that

- LVM offer the support of snapshots, by copying the metadata that describes the current file system
  - snapshots are read-only copies of a logical volume
  - snapshots are used to create backups of logical volumes
  - snapshots are also used to create consistent backups of databases

### Creating LVM Logical Volumes
- LVM involves creating the three layers in the following order
  - **Physical Volumes (PV)**  -> physical storage devices
  - **Volume Group (VG)s**     -> collection of physical volumes
  - **Logical Volumes (LV)**   -> logical partitions that are created on volume groups

1. Create a physical volume with the partition marked as LVM partition
  - `fdisk <device_name>` -> start fdisk utility
    - `t`   -> change the partition type
    - `8e`  -> change the partition type to LVM
    - `w`   -> write the changes to the disk
    - `q`   -> quit fdisk utility
  - `partprobe <device_name>` -> update kernel partition table
  - `pvcreate <device_name>`  -> create a **physical volume**
  - `pvs` or `pvdisplay`      -> list all the physical volumes that are available to our system

2. Creating a volume group with the physical volume
  - `vgcreate <vg_name> <device_name>` -> create a **volume group**
  - `vgcreate -s <size> <vg_name> <device_name>` -> create a **volume group** with specific size, default size is **4MB** and maximum size is **128MB**
  - `vgs` or `vgdisplay`               -> list all the volume groups that are available to our system

3. Creating logical volumes and file systems
  - `lvcreate -L <size> -n <lv_name> <vg_name>` -> create a **logical volume** with specifc size
    - `lvcreate -L 1G -n lv1 vg1` -> create a **logical volume** with 1GB size
  - `lvcreate -l <size> -n <lv_name> <vg_name>` -> create a **logical volume** with relative size
    - `lvcreate -l 100%FREE -n lv1 vg1` -> create a **logical volume** to use of all of the available space in the volume group
  - `lvs` or `lvdisplay` -> list all the logical volumes that are available to our system
  - `mkfs -t <fs_type> <lv_path>` -> format a logical volume
    - `mkfs.xfs <lv_path>` -> format a logical volume with XFS filesystem
    - `mkfs.ext4 <lv_path>` -> format a logical volume with EXT4 filesystem

- LVM volume devices name can be multiple ways, but the most common way is `/dev/<vg_name>/<lv_name>`
- for naming LVM volumes another system plays a role called device mapper, Kernel uses to address storage devices
  - it creates meaningless names like `/dev/dm-0` and `/dev/dm-1`, for easier access device mapper creates symbolic links in `/dev/mapper/` directory

### Resizing LVM Logical volumes

4. Resizing volume groups
  - `vgextend <vg_name> <device_name>` -> add a physical volume to a volume group
  - `vgreduce <vg_name> <device_name>` -> remove a physical volume from a volume group
  - after extending a volume group we now can extend the logical volume
  - `lvresize -L +1G -r <lv_path>` -> resize the file system used on it as well
    - `lvresize -L +1G -r /dev/vg1/lv1` -> resize the logical volume by 1GB and resize the file system used on it as well
    - `lvresize -l +100%FREE -r /dev/vg1/lv1` -> resize the logical volume to use all of the available space in the volume group and resize the file system used on it as well
  - `lvextend -L +1G -r <lv_path>` -> extend the logical volume by 1GB and resize the file system used on it as well
    - `lvextend -L +1G -r /dev/vg1/lv1` -> extend the logical volume by 1GB and resize the file system used on it as well
    - `lvextend -l +100%FREE -r /dev/vg1/lv1` -> extend the logical volume to use all of the available space in the volume group and resize the file system used on it as well

- the size of XFS file system can't be decreased it can only be inceresed
- inorder to have a file system that can be shrunk in size we use EXT4 file system

## Configuring Stratis
- There are two advanced storage types, whcich are called as volume manament system
  - **Stratis**
  - **VDO** 

- There are many advantages with stratis
  - **Thin Provisioning** -> enables a stratis file to present itself to users as much bigger than it really is
    - virtual desktops see 20GB of storage space, although much lower amoutn is actually provisioned to each user
  - **Snapshots** -> enables to create snapshots of file systems, which has current state of file system
  - **Cache tier** -> **Ceph** storage feature that ensures that data can stored physically closer to the Ceph clients which makes the access faster
  - **Programming API** -> API ensures that storage can be managed programmatically
  - **Monitoring and repair** -> old systems require tools like `frisk`, stratis has built-in monitoring and repair tools

### Understanding Stratis Architecture
- lowest layer in the stratis architecture is the **pool**
- from a functional perspective stratis pool is comparable to LVM volume group
- it represents all available storage and consists of one or more **physical volumes**
- Stratis environment is referred to as **blockdev**, these block devices may no t be thin provisioned at the underlying hardware level
- Stratis creates a `/dev/stratis` poolname directory for each pool
- from stratis pool XFS file systems are created, stratis only works with XFS file systems 
- the XFS file systems it uses is integrated with the Stratis Volume, which means that the file system can be resized when the pool is resized

## Creating Stratis Storage
- Creating a stratis Volume
  1. Start be creating a pool
  2. Create a file system on the pool

- We need make sure that the block devices we use in stratis have a minimal size of `1GB`
- each stratis file system occupies a minimum of 527MB of space even if it's empty

- `yum install stratisd stratis-cli` -> install stratisd and stratis-cli packages
- `systemctl enable --now stratisd` -> enable and start stratisd service
- `stratis pool create` -> create a stratis pool
  - `stratis pool create <pool_name> <device_name>` -> create a stratis pool
  - `stratis pool list` -> list all the stratis pools that are available to our system
  - `stratis pool add-data <pool_name> <device_name>` -> add a physical volume to a stratis pool
  - `stratis pool remove-data <pool_name> <device_name>` -> remove a physical volume from a stratis pool
  - `stratis pool destroy <pool_name>` -> destroy a stratis pool
- `stratis fs create` -> create a stratis file system
  - `stratis fs create <pool_name> <fs_name>` -> create a stratis file system
  - `stratis fs list` -> list all the stratis file systems that are available to our system
  - `stratis fs destroy <fs_name>` -> destroy a stratis file system
- after the creating the file system you can mount it
  - to mount stratis file system through `/etc/fstab` you must use the UUID using `blkid` command
  - we must add the mount option as `x-systemd.requires=stratisd.service` to make sure that the stratisd service is started before the file system is mounted

### Managing Stratis
- after the creation of stratis file system we can perform server different management tasks
- `stratis blockdev` -> list all the block devices that are available to our system
  - `stratis blockdev list-pools` -> list all the stratis pools that are available to our system
- `stratis pool` -> gives info about stratis pools
- `stratis fs` -> gives info about stratis file systems

- we can also manage snapshots using stratis that contains the file system metadata

## Configuring VDO
- VDO stands for **Virtual Data Optimizer**, a solution that was developed to offer data deduplication features
- was developed to reduce disk space usage on block devices by removing duplicate copies of data
- VDO creates volumes, implements data deduplication and compression on any type of existing block device (`blkid`)
- It performs deduplication using
  - **Zero block elimination** -> removes blocks that contain only zeros
  - **deduplication** removes dublicate blocks of data
  - **Compression** occurs when kvdo kernel module compress data blocks

- VDO is typically used in host systems that run virtual machines, where the deduplication engine ensures much more disk storage use.

### Setting up VDO
- `yum install vdo kmod-vdo` -> install vdo package
- `vdo create` -> create a vdo volume
  - `vdo create --name=<vdo_name> --device=<device_name> --vdoLogicalSize=<size>` -> create a vdo volume
    - `vdo create --name=vdo1 --device=/dev/sdb --vdoLogicalSize=10G` -> create a vdo volume
  - `vdo list` -> list all the vdo volumes that are available to our system
  - `vdo remove <vdo_name>` -> remove a vdo volume
- after creating VDO we need to put a file system on top
- `mkfs.xfs -K /dev/mapper/vdo1` -> format a vdo volume with XFS file system
  - `-K` -> don't use the discard option, prevents unused blocks in file system from being discarded
- to make the mount permanent we need to add the vdo volume to the `/etc/fstab` file
  - we need to make sure to include the mount options `x-systemd.requires=vdo.service,discard` to make sure that the vdo service is started before the file system is mounted
- `vdostats --human-readable` -> gives info about vdo volumes

- we need to copy the sample mount unit file form `/usr/share/doc/vdo/example/systemd/VDO.mount.example` to `/etc/systemd/system/` directory
- we need to change the `what` and `where` based of the requirements. and upon reboot the vdo volume will be mounted automatically