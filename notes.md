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

