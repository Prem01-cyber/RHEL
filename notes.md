- [RHEL 8 - EX200](#rhel-8---ex200)
  - [Lab Setup](#lab-setup)
- [Basics](#basics)
  - [Command Execution Process](#command-execution-process)
  - [IO Redirection](#io-redirection)
  - [Shell Environment](#shell-environment)
  - [Help Commands](#help-commands)
    - [Man Pages](#man-pages)
  - [info](#info)
  - [Documentation Pages](#documentation-pages)
- [File Management](#file-management)
  - [Mount Command](#mount-command)
  - [Links](#links)
    - [Hard Links](#hard-links)
    - [Soft Links or Symbolic Links](#soft-links-or-symbolic-links)
    - [Creating links](#creating-links)
    - [Removing links](#removing-links)
  - [Archiving files](#archiving-files)
  - [Compressing files](#compressing-files)
- [Working with Text Files](#working-with-text-files)
  - [Common file related tools](#common-file-related-tools)
  - [Finding Text in a file](#finding-text-in-a-file)
  - [Advanced Text Processors](#advanced-text-processors)
- [Connecting to RHEL](#connecting-to-rhel)
  - [Logging in to a local console](#logging-in-to-a-local-console)
  - [Working with multiple terminals](#working-with-multiple-terminals)
  - [Booting Rebooting and shutting down](#booting-rebooting-and-shutting-down)
  - [Accessing Systems Remotely](#accessing-systems-remotely)
    - [Key Based Authentication](#key-based-authentication)
    - [Screen (Not for RHCSA)](#screen-not-for-rhcsa)
  - [Transfering files Securely](#transfering-files-securely)
- [User and Group management](#user-and-group-management)
  - [User types](#user-types)
  - [Managing User accounts](#managing-user-accounts)
    - [Creating User](#creating-user)
    - [Removing User](#removing-user)
    - [Modifying User](#modifying-user)
  - [Managing password properties](#managing-password-properties)
  - [Creating a user environement](#creating-a-user-environement)
  - [Group accounts](#group-accounts)
    - [Creating groups](#creating-groups)
    - [Modifying groups](#modifying-groups)

# RHEL 8 - EX200

## Lab Setup
- ISO Image - rhel-9.2-x86_x64-dvd.iso
- Configuration
  - Memory: 4GB
  - Processor: 4
  - Hard Disk: NVME 80GB
  - Hostname: localhost.localdomain
- ISO Image - rhel-8.8-x86_x64-dvd.iso

# Basics
## Command Execution Process
- **Internal Command** - Built-in command - part of shell itself
- **External Command** - Binary file - Doesn't exist as an executable file
- The shell first looks at the command and determines if its an internal command or an external command and then executes it.
- If it's an internal command it executes it directly, else it searches for the command in the **PATH** variable.

## IO Redirection
- **STDIN** - Standard Input - `0` - `<`
- **STDOUT** - Standard Output - `1` - `>`
- **STDERR** - Standard Error - `2` - `2>`
- **STDOUT & STDERR** - `&>` or `2>&1` - Send both STDOUT and STDERR to the same file

## Shell Environment
- **Environment Variables** - Variables that are set in the shell environment
  - `$PATH` - Contains the list of directories where the shell searches for commands
  - `$HOME` - Home directory of the user
  - `$PWD` - Present Working Directory
  - `en_US.UTF-8` - Language and encoding - `$LANG`


- **Environemnt Configuration Files**
  - `/etc/profile` - System wide configuration file, processed by all users upon login
  - `/etc/profile.d/*.sh` - System wide configuration files
  - `~/.bash_profile` - User specific configuration file
  - `~/.bashrc` - User specific configuration file
  - `~/.bash_logout` - User specific configuration file


- `/etc/motd` - Message of the day - Displayed after login
- `/etc/issue` - Displayed before login

## Help Commands
- `man` - Manual pages
  - `/example` -> Search for example in the manual page
  - `n` -> Next match
  - `N` -> Previous match
- `info` - Info pages
- `apropos` or `man -k` - Search for commands
- `whatis` - Display one line description of a command
- `--help` - Display help for a command, nearly all commands have this option available

### Man Pages
- man pages are categorized into 9 sections
  - **1**   - Executable programs or shell commands
  - 2       - System calls
  - 3       - Library calls
  - 4       - Special files
  - **5**   - File formats and conventions
  - 6       - Games
  - 7       - Miscellaneous
  - **8**   - System administration commands
  - 9       - Kernel routines

- To get a short description of the command we can use `man -f command` or `whatis` command
- When searching for commands manual page it consults the `mandb` database, this db is automatically created using `cron` scheduled job
- Ocassionally we might face an error stating `nothing appropriate`, at whcih point we can use `mandb` command to update the database
- To update the man db we might be required to have the sudo privileges

## info
- we can read the documentation of some commands using `info` or `pinfo`.
- `pinfo` is a more user friendly version of `info` command
- The controls are typically same as `man` pages

## Documentation Pages
- `/usr/share/doc` - Contains documentation for installed packages
- These are available in particular services and larger systems that are bit more complicated
- For instance, `rsyslog`, `bind`, `Kerberos`, `OpenSSl`

# File Management
- [File System Structure](./File_system.md)
- File selection wildcards
  - `*` - Wildcard - Matches any number of characters
  - `?` - Wildcard - Matches any single character
  - `[]` - Wildcard - Matches any single character within the brackets
- Paths
  - absolute path - `/home/user1`
  - relative path - `./user1` or `../user1`
- [Working with files and directories](./Working_with_files_and_directories.md)


## Mount Command
- `mount` command gives overview of all mounted devices and also allows us to mount new devices
- The output of the `mount` command is based on `/proc/mounts` file, where keranel keeps information about mounted devices
  - `df -Th`    -> Gives a better overview of the mounted devices, where `-T` gives the file system type
  - `findmnt`   -> shows the relationship between mounts

## Links
- Linux stores information in the form of **inodes**, which are unique identifiers for files and directories. It contains
  - the **data block** where the file contents are stored
  - CAM dates
  - permissions
  - file owners

- A file can have multiple names, which are called links

### Hard Links
- Hard links are just another name for the same file
- Basically when we create a file we are creating a hard link
- Hard links can't be created for directories and files on different file systems
- They must exist on same partition of logical volume
- In linux file system multiple hard links can be created for a single file
- If we delete a hard link, the file still exists as long as there is atleast one hard link to it

### Soft Links or Symbolic Links
- Soft links are just pointers to the original file, they are not the same file
- Unlike hard links soft links can link to files on other devices
- The symbolic link becomes invalid if the original file is deleted

### Creating links
- `ln` command is used to create links (Hard link by default)
- `ln -s` is used to create soft links

### Removing links
- Removing links can be dangerous especially the soft links
- Never use `-f` or `-r` options with `rm` command while removing links

## Archiving files
- `tar` -> Tape Archive, stores multiple files in a single file. It doesn't actually compress.
- `tar -cvf archive.tar file1 file2` -> **Create** archive withf iles with verbosity
- `tar -rvf archive.tar file3` -> **Append** file3 to archive with verbosity
- `tar -uvf archive.tar file4` -> **Update** file4 in archive with verbosity

- there is a significant difference between update and append in tar. 
- if we add an existing file to the archive append will create a new copy of the file, whereas update will update the existing file in the archive based on the timestamp.

- `tar -tvf archive.tar` -> **List** files in archive with verbosity
- `tar -xvf archive.tar` -> **Extract** files from archive with verbosity
- `tar -xvf archive.tar -C /tmp` -> **Extract** files from archive to a specific directory with verbosity

## Compressing files
- `gzip` -> GNU zip, compresses a single file. `bzip2` is an alternate
- `gunzip` and `bunzip2` are used to decompress the files
- `tar -zcvf archive.tar.gz file1 file2` -> **Create** archive with files with verbosity and compress using gzip
- `tar -jcvf archive.tar.bz2 file1 file2` -> **Create** archive with files with verbosity and compress using bzip2

# Working with Text Files

## Common file related tools
- `less`    -> Displays the contents of a file, but it doesn't load the entire file into memory. It loads the file in chunks.
  - Navingation is pretty similar to `vim`
- `cat`     -> Displays the contents of a file, but it loads the entire file into memory.
  - `tac`  -> Displays the contents of a file in **reverse** order
- `head`    -> Displays the **first** 10 lines of a file
  - `head -f /var/log/messages` -> Displays the **first** 10 lines of a file and keeps on updating the output as the file grows.
  - `head -n 5 /etc/passwd`     -> Displays only the first 5 lines
- `tail`    -> Displays the **last** 10 lines of a file
  - `tail -f /var/log/messages` -> Displays the **last** 10 lines of a file and keeps on updating the output as the file grows
  - `tail -n 5 /etc/passwd`     -> Displays last 5 lines
- `cut`     -> Displays a specific column of a file
  - `cut -f 1 -d : /etc/passwd` -> Displays the first column of the file, where `-f` is the field and `-d` is the delimiter
  - we can use `$'\t'` for tab as delimiter
- `sort`    -> Sorts the contents of a file, default it sorts in ascending order
  - `sort -r` -> Sorts in descending order
  - `sort -n` -> Sorts numerically
  - `sort -k 3` -> Sorts based on the third column
  - `sort -t : -k 3` -> Sorts based on the third column and the delimiter is `:`
- `wc`      -> Displays the number of lines, words and characters in a file

## Finding Text in a file
- `grep`    -> Searches for a pattern in a file
  - `grep -i` -> Ignores case
  - `grep -v` -> Inverts the match
  - `grep -r` -> searches files in the current directory and all sub directories
  - `grep -w` -> Searches for whole words
  - `grep -c` -> Displays the count of matches
  - `grep -E` -> Uses extended regular expressions, which allows us to use `|` and `()`
  - `grep -e` -> matches multiple regular expressions

- We can also use anchors with grep similarly wildcards can also be used
  - `grep ^root /etc/passwd` -> Searches for lines starting with root
  - `grep root$ /etc/passwd` -> Searches for lines ending with root

## Advanced Text Processors
- `awk` 
  - `awk -F : '{print $1}' /etc/passwd` -> Prints the first column of the file, where `-F` is the field and `:` is the delimiter
- `sed`
  - `sed -i -e '2d' /etc/passwd` -> Deletes the second line of the file
  - `sed -i -e '2d;20,25d' /etc/passwd` -> Deletes the second line and lines 20 to 25 of the file

# Connecting to RHEL 
- `console`   -> Environment that the user looks at
- `terminal`  -> The program that the user uses to interact with the console
- In a textual environment console and terminal are the same, but in a graphical environment they are different
- In a graphical environment we can have multiple terminals on a console, but opposite is not possible


- `tty`       -> Displays the terminal that we are currently using

## Logging in to a local console
- There are two cases
  1. **Textual console** - login from a login prompt
  2. **Graphical console** - login from a graphical login screen

- a **root** user is always present, we can login using `su -` or `su - root` or `su -l root`
- - `w` -> Displays the list of users logged in and the processes they are running

## Working with multiple terminals
- We can open upto 6 **virtual terminals**, which are accessible using `Ctrl + Alt + F1` to `Ctrl + Alt + F6`
  - **F1**      -> GNOME Display manager
    ![GNOME Display Manager](./assets/Screenshot%20from%202023-11-03%2023-21-38.png)
  - **F2**      -> Current Graphical console
    ![Current Graphical console](./assets/Screenshot%20from%202023-11-03%2023-22-13.png)
  - **F3**      -> Current grphical session
    ![Current grphical session](./assets/Screenshot%20from%202023-11-03%2023-22-38.png)
  - **F4 - F6** -> Non graphical consoles

- To change through the virtual terminals we can also use `chvt 1-6` command
- The first one is the default console known as **virtual console tty1** and the respecitve device file is `/dev/tty1`
- if we open a terminal in an environment a device file is create
  - if opened in a **graphical environment** - `/dev/pts/0` - **pseudo terminal**
  - if opened in a **textual environment** - `/dev/tty2` - **virtual terminal**

## Booting Rebooting and shutting down
- Rebooting is a neccessary task, because it clears the memory and also loads the new kernel
- Knowing which parameter to trigger is essentially a crucial part in rebooting the system while stuck

- To issue a proper reboot we have to alert **Systemd** process, which is the **first process** that is started by the kernel
- `systemctl` is the command that is used to interact with the systemd process
  - `systemctl reboot` -> Reboots the system or `reboot`
  - `systemctl poweroff` -> Shuts down the system or `shutdown -h now`
  - `systemctl halt` -> Halts the system, stops the system abruptly or `halt`

- In some cases these commands might not working due to some issues, there are some alternatives to reboot the system
  - `echo -b > /proc/sysrq-trigger` -> to force a machiene to reset

## Accessing Systems Remotely
- `ssh` -> Secure Shell, is a protocol that allows us to connect to a remote system securely
  - `ssh user@host` -> Connects to the remote system
  - `ssh remoteserver -l user` -> Connects to the remote system
  - `ssh -p 2222 user@host` -> Connects to the remote system on a specific port


- `sshd` -> Secure Shell Daemon, is the service that runs on the remote system and listens for incoming connections
  - `systemctl status sshd` -> Displays the status of the sshd service
  - `systemctl start sshd` -> Starts the sshd service

### Key Based Authentication
- To make ssh a bit more secure we can use **Key Based Authentication**
  - `ssh-keygen` -> Generates a public and private key pair, the user who wants to connect to a server
  - `ssh-copy-id user@host` -> Copies the public key to the remote host
  - Once we have copied to the target it get's stored in `~/.ssh/authorized_keys`
  - `ssh -i ~/.ssh/id_rsa user@host` -> Connects to the remote system using the private key


- After we connect to remote host the **identity** of the remote host is stored in the `~/.ssh/known_hosts` file
- By default we can't start a **graphical session** using ssh, which actually requires **RDP** or **VNC**. 
- But we can use **X11 forwarding** to start a graphical session
  - `ssh -X user@host` -> Connects to the remote system and starts a graphical session, security extensions are enabled here
  - `ssh -Y user@host` -> Connects to the remote system and starts a graphical session, but it's less secure

- We can create a system wide configuration that allows you to use **X Forwarding** by default
  - `sudo vim /etc/ssh/ssh_config`
  - `ForwardX11 yes`
  - `ForwardX11Trusted yes`

### Screen (Not for RHCSA)
- `screen` is a terminal multiplexer, which allows us to run multiple terminals in a single terminal
  - `yum install -y epel-release`   -> Installs the epel repository, which has screen
  - `yum install -y screen`         -> Installs the screen package

- Screen is particulary useful in a ssh session, which allows us to dettach and reattch the ssh session using certian shortcuts
- `screen` to create a new terminal and `screen -r` to dettach the session

## Transfering files Securely
- if a host is running `sshd` service then we can use it to transfer files using `scp` command to copy or `rsync` to synchronise the file
  - `scp file1 user@host:/tmp` -> Copies the file to the remote system
  - `scp user@host:/tmp/file1 .` -> Copies the file from the remote system
  - `rsync -avz file1 user@host:/tmp` -> Synchronises the file to the remote system
  - `rsync -avz user@host:/tmp/file1 .` -> Synchronises the file from the remote system

- `scp` and `rsync` command provides an interface similar to `cp` command. `sftp` is similar to `FTP`
- `sftp` is also a command that can be used to transfer files, but it's not as efficient as `scp` or `rsync`
  - We open a **client-session** on remote server and then transfer files
  - We use `put` to upload and `get` to download similar to FTP commands

# User and Group management
## User types
- `id` -> Displays the user id and group id of the current user
  - `0`     -> root user or superuser
  - `1-999` -> System users
  - `1000+` -> Regular users

- `su` -> Switch User, allows us to switch to another user
  - `su -` -> Switches to root user, all the variables are set correctly if `-` is used
  - `su - user1` -> Switches to user1
  - `su -l user1` -> Switches to user1

- `sudo` -> Super User Do, allows us to execute commands as another user (Non root user)
  - `sudo -u user1 id` -> Executes the `id` command as user1
  - `sudo -i` -> Switches to root user, all the variables are set correctly if `-i` is used
  - `sudo -l` -> Lists the commands that the current user can execute as another user or root, `sudo -ll` give long listing format

- we can grant root privileges to a specific user during installation or we can do it manually by adding the user to `wheel`
  1. `visudo` -> Opens the sudoers file, which is used to grant root privileges to a user
  2. `usermod -aG wheel user1` -> Adds the user1 to the wheel group
      - and adding `%wheel ALL=(ALL) ALL)`, which means all the users in the wheel group can execute all commands as root

- Most admin programs with GUI use **Policy Kit** to authenticate as root user, just prompted for auth in graphical interface
  - `pkaction` -> Displays the list of actions that can be executed by the current user
  - `polkit` -> Policy Kit, is the service that is responsible for authenticating users
  - `pkexec` -> Executes a command as another user
    - `pkexec id` -> Executes the `id` command as root user
    - `pkexec -u user1 id` -> Executes the `id` command as user1

![Policy Kit](./assets/Screenshot%20from%202023-11-04%2009-52-01.png)

## Managing User accounts
- **/etc/passwd** -> Contains the list of users on the system
  - `user1:x:1000:1000:User 1:/home/user1:/bin/bash`
    - **user1** -> Username
    - **x** -> Password, **x** means the password is stored in **/etc/shadow**
    - **1000** -> User ID
    - **1000** -> Group ID
    - **User 1** -> User's full name
    - **/home/user1** -> Home directory
    - **/bin/bash** -> Default shell
      - This is the program that is started after the user has connected to the server
      - system user accounts (1-999) have `/sbin/nologin` as default shell
      - regular user accounts (1000+) have `/bin/bash` as default shell
      - `/sbin/nologin` -> Prevents the user from logging in


- **/etc/group**  -> Contains the list of groups on the system or we can use `groups` command
- **/etc/shadow** -> Contains the list of users and their passwords
  - `user1 : $6$1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X/: 18953:0:99999:7:::`
    - **user1** -> Username
    - **$6$1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X1X2X3X4X5X6X7X8X9X0X/** -> Password
    - **18953** -> Last password change since epoch (Jan 1, 1970)
    - **0** -> Minimum password age
    - **99999** -> Maximum password age
    - **7** -> Password warning period
    - **:::** -> Inactive

### Creating User
- There are many ways to create a user
  1. Mondifying **/etc/passwd** and **/etc/shadow** directly using `vipw` for /etc/passwd and `vipw -s` for shadow, has many risks though
  2. `useradd` command utility
      - `useradd -m -u 1201 -G sales,ops linda` -> Creates a user with user id 1201 and adds the user to sales and ops group

- `useradd` command creates the user, but it doesn't set the password, we need `passwd` to set the password
  - `passwd linda` -> Sets the password for the user linda
  - `passwd -e linda` -> Expires the password for the user linda, which means the user has to change the password on next login

- When a home directory is created the contents of **/etc/skel** is copied to the home directory
- These files would also get appropriate permissions based on the new user

- While working with `useradd` some default values are assumed
  - `useradd -D` or `/etc/default/useradd`  -> Displays the default values
  - `/etc/login.defs`                       -> Login default values, motd, envpath, password aging, home creation.

### Removing User
- `userdel` commands is used to remove user
- `userdel -r` -> Removes the user and the home directory (removes complete user environment)

### Modifying User
- we could modify user properties with `vipw` or we could use the `usermod` command line utility
- `usermod -p` -> its tells to use encrypted password for the new password

- [Go to Modifying groups section](#modifying-groups)

## Managing password properties
- passwords are present in **/etc/shadow**, the properties can be changed manually using `vipw -s` or we can use `chage` and `passwd` commands
  - `passwd -n 30 -w 3 -x 90 -i 7 linda` -> Sets the password properties for the user linda
    - `-n` -> Minimum password age
    - `-w` -> Password warning period
    - `-x` -> Maximum password age
    - `-i` -> Inactive
  - `chage -E 2025-12-31 bob` -> Sets the password expiration date for the user bob
  - `chage -l bob` -> Displays the password properties for the user bob
  - `chage anna` -> **interactive** way of changing password properties

## Creating a user environement
- When a user logs in, the shell reads the configuration files and sets the environment variables. 
- all the environemnt variables can be viewed through `printenv` command
- There are specific files that play a role in creating user environment
  - **/etc/profile**    -> default settings for all users when starting a login shell
  - **/etc/bashrc**     -> defines default settings for all users when starting a non-login shell
  - **~/.bash_profile** -> default settings for a specific user when starting a login shell
  - **~/.bashrc**       -> default settings for a specific user when starting a non-login shell+

- A login shell is the first shell that is run when you login into a Unix-like operating syste. it's the parent of all your other shells
- A non-login shell, on the other hand, is a shell that is started after the login shell
- For example, when you open a terminal window from the graphical user interface, you are starting a non-login shell.

- a login shell executes
  1. **/etc/profile**
  2. looks for **~/.bash_profile**, **~/.bash_login**, and **~/.profile** in that order

- a non-login shell executes
  1. **~/.bashrc**

## Group accounts
- Every linux user has a **primary group (itself)** and can be a member of multiple groups
- Users can access all files their primary group has access to and all files that their secondary groups have access to

- we can list groups using `groups` command which uses `/etc/group` file.
- `id` also lists the groups that the user is a member of

### Creating groups
- `groupadd` command is used to create groups
  - `groupadd -g 1201 sales` -> Creates a group with group id 1201 and name sales

- we can also add groups manually using `vigr` which allows us to edit the `/etc/group` file directly, which is rather unsafe

### Modifying groups
- `groupmod` command is used to modify groups
  - `groupmod -n sales1 sales` -> Renames the group sales to sales1
  - `groupmod -g 1202 sales1` -> Changes the group id of sales1 to 1202

- Once a new group is added we can use `usermod` to add users to the group
  - `usermod -aG sales1 linda` -> Adds the user linda to the group sales1

- `groupmems` is a convinient way to list the members of a group
  - `groupmems -g sales -l` -> Lists the members of the group sales
