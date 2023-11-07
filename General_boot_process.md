- [Linux booting sequence](#linux-booting-sequence)
  - [POST (Power On Self Test)](#post-power-on-self-test)
  - [BIOS (Basic Input/Output System)](#bios-basic-inputoutput-system)
  - [MBR (Master Boot Record)](#mbr-master-boot-record)
  - [GRUB (GRand Unified Bootloader)](#grub-grand-unified-bootloader)
    - [Modifying default GRUB2 Boot options](#modifying-default-grub2-boot-options)
    - [Kernal](#kernal)
    - [Initramfs](#initramfs)
  - [Init](#init)
- [Note](#note)

# Linux booting sequence
- systemd is responsible for starting all kinds of things.
- go to notes4 for more information about targets

- Four targets can be used while booting
  - `rescue.target` - target starts all units that are required to get fully operable linux os, it doesn't start non essential ones
  - `emergency.target` - target starts minimal number of units, just enough to fix your system if it is broken
  - `multi-user.target` - target is often used and it starts everything needed for full system functionality and is used on servers
  - `graphical.target` - target is used on desktops and it starts everything needed for full system functionality and GUI also

## POST (Power On Self Test)
- POST is a test sequence that runs when you first turn on your computer.
- POST is responsible for the following tasks:
  - Checks the status of the hardware
  - Checks for a valid boot sector on the boot device
  - Initializes the BIOS, CMOS, and other components
  - Searches for an operating system to boot
  - Loads the MBR into memory and transfers control to it

## BIOS (Basic Input/Output System)
- BIOS is a firmware that is built into the motherboard.
- Nowadays it has been replaces with UEFI (Unified Extensible Firmware Interface).
- UEFI has more features than BIOS
- BIOS checks for MBR (Master Boot Record) on the boot device.

## MBR (Master Boot Record)
- MBR is a 512-byte sector that is located at the first sector of the boot device.
- It contains the following information:
  - Boot loader (GRUB or LILO(Linux Loader))
  - Partition table
- It then hands over control to the boot loader.

## GRUB (GRand Unified Bootloader)
- GRUB is a multiboot boot loader, which means that you can have multiple operating systems installed on your computer and choose which one to boot when you turn on your computer.
- GRUB is located at **/boot/grub/grub.conf**
- Currently we are using GRUB2 which is located at **/boot/grub2/grub.cfg**
- On an UEFI system the location of GRUB2 is **/boot/efi/EFI/redhat/grub.cfg**
  - these files are automatically generated and should not be edited manually

- GRUB 2 bootloader makes sure you can boot linux, it works just fine it doesn't require maintainance
- But in some cases we might want to change the configuration of GRUB 2 bootloader
  - the starting point would be `/etc/default/grub` file
  - the most important part of the configuration is `GRUB_CMDLINE_LINUX` variable
  - which contains boot arguments for linux kernel

- After getting control from MBR GRUB loads the kernel into memory and transfers control to it.

### Modifying default GRUB2 Boot options
- To modify the default GRUB2 boot options, we need to edit the **/etc/default/grub** file.
  - some likely changes to troubleshoot are removing the `rhgb` and `quiet` options
  - removing these options will show the boot process in detail
- After making changes to the **/etc/default/grub** file, we need to run the `grub2-mkconfig` command to generate the **/boot/grub2/grub.cfg** file.
  - alternative we can remove the options in the boot by pressing `e` and `esc` while booting

- To make the changes permanent, we need to run the `grub2-mkconfig` command with the `-o` option to specify the **/boot/grub2/grub.cfg** file.
  - `grub2-mkconfig -o /boot/grub2/grub.cfg`          -> for a BIOS system
  - `grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg` -> for an UEFI system

### Kernal
- Kernel is the core of the operating system.
- The name of the linux keranl is **VM-linuz**. It is located at **/boot/vmlinuz*
- It basically interacts with the hardware and provides services to the user space processes.
- It is responsible for the following tasks:
  - Hardware management
  - Process management
  - Memory management
  - File system management
  - Device management
  - Security management
  - Network management
  - User interface management
- After getting control form GRUB kernel loads the its splash image first with the help of initamfs, file whcih are accessed without mounting the root file system.
- Kernel is loaded into memory and transfers control to the init process.

### Initramfs
- Initramfs is a temporary file system that is loaded into memory.
- It contains the following information:
  - Kernel modules
  - Device drivers
  - Other utilities that are required to mount the root file system

## Init
- Init is the first process that is started after the kernel is loaded.
- The process ID of INIT is 1.
- After loading itself then it loads the whole OS.
- There are several run levels in linux. Each run level has its own purpose.
- The run levels are as follows:
  - 0 - Shutdown                                  -> poweroff.target
  - 1 - Single user mode                          -> rescue.target
  - 2 - Multi user mode without networking
  - 3 - Multi user mode with networking           -> multi-user.target
  - 4 - Not used
  - 5 - Multi user mode with networking and GUI   -> graphical.target
  - 6 - Reboot                                    -> reboot.target  
- The default run level is 3.

# Note
- This is a general boot process of linux and not the one used by redhat linux.
- In redhat linux the boot process is different. Namely it uses **systemd** instead of **init**.
- We also don't use **GRUB** in redhat linux. We use **GRUB2**.
- We also don't use **MBR** in redhat linux. We use **GPT**.
- We also don't use **BIOS** in redhat linux. We use **UEFI**.
- We also don't use **initramfs** in redhat linux. We use **initrd**.
- We also don't use **vmlinuz** in redhat linux. We use **vmlinux**.
- We also don't use **run levels** in redhat linux. We use **targets**.