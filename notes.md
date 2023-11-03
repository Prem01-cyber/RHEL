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