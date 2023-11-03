# Linux File System Structure
- Linux file system is a tree like structure.
- The **root** directory is represented by a forward slash **/**.

1. **/bin** - Contains binary files and commands.
2. **/sbin** - Contains system binary files and commands.
3. **/boot** - Contains boot loader files.
4. **/dev** - Contains device files.
5. **/etc** - Contains configuration files.
6. **/home** - Contains home directories of users.
7. **/lib** - Contains shared libraries. which are used by bin and sbin.
8. **/media** - Contains mount points for removable media.
9. **/mnt** - Contains mount points for temporary file systems.
10. **/opt** - Contains optional or third party software. Outside distribution package manager.
11. **/proc** - Contains information about processes and system resources.
12. **/root** - Home directory of root user.
13. **/run** - Contains information about running processes.
14. **/srv** - Contains data for services provided by the system.
15. **/sys** - Contains information about devices, drivers and some kernel features.
16. **/tmp** - Contains temporary files.
17. **/usr** - Contains user related programs and data.
18. **/var** - Contains variable data like logs, mail, print queues, etc.

- Depending on the flavor of linux, some directories may be missing or some may be added.

## Boot Directory
- In the boot directory we can find 
  - **initramfs** -> It contains the **initramfs** file which is a temporary file system that is loaded into memory.
  - **vmlinuz** -> It contains the **kernel** file.
  - **grub2** -> Boot loader files.
- These files are copied to the ram at the time of booting.

## Etc Directory
- Contains system configuration files.
  - **/etc/skel** -> Used for creating new user home directories.
  - **/etc/passwd** -> Contains user account information.
  - **/etc/yum** -> Contains yum configuration files.

## Home Directory
- Contains home directories of users. The root has its own home directory. Which is **/root**.
- The home directory of a user is **/home/username**.
- by default a new user gets profile files
  - **.bash_profile** -> Contains user specific environment variables.
  - **.bash_logout** -> Contains commands that are executed when a user logs out.
  - **.bashrc** -> Contains bash shell specific commands.

- We can mount home directory of users with specific options, for instance **noexec** and **nodev** would prevent users from executing binaries and mounting devices respectively.

## Root Directory
- **anaconda-ks.cfg** -> Contains the kickstart file. Which is used for kickstart installation. It can also be created manually. It is also used for installing multiple systems at once with similar configuration.
- **original-ks.cfg** -> Contains the original kickstart file.

## srv Directory
- Contains data for services provided by the system.
- For example, if we are using a **web server**, then the web server will store its data in this directory.
  - **/srv/ftp** -> Contains ftp data.
- Generally this directory is empty. It is used by the system administrator to store data.

## media Directory
- Contains mount points for removable media.
- For example, if we insert a CD or a USB drive, then it will be mounted in this directory.
- It is empty by default.

## mnt Directory
- Contains mount points for temporary file systems.
- For example, if we mount a file system temporarily, then it will be mounted in this directory.
  - **/mnt/cdrom** -> Contains the CDROM file system.
- It is empty by default.

## tmp Directory
- By default we have **sticky bit**(Prevents users to delete files of other users) set on this directory.
- This directory is only one that is used by all the users collectively. It is not user specific.

## dev Directory
- Contains device files. These files are used to interact with the hardware. 
- For example, if we want to interact with the hard disk, then we will use the device file of the hard disk.
- terminal information is also stored in this directory. For instance **/dev/pts/0**
- **/dev/null** is a special file. If we write something to this file, then it will be discarded. It is used for deleting files permanently. We can't read the file.

## proc Directory
- Contains information about processes and system resources.
- It is a virtual file system. It is not stored on the hard disk. It is created by the kernel.
  - For instance **/proc/cpuinfo** contains information about the cpu.
- We can use these files to get information about the system.

## var directory
- Contains log files, mail, print queues, etc.
  - **/var/log** -> Contains log files.
  - **/var/messages** -> Contains system messages.