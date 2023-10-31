# Linux booting sequence
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

### Initramfs
- Initramfs is a temporary file system that is loaded into memory.
- It contains the following information:
  - Kernel modules
  - Device drivers
  - Other utilities that are required to mount the root file system

## GRUB (GRand Unified Bootloader)
- GRUB is a multiboot boot loader, which means that you can have multiple operating systems installed on your computer and choose which one to boot when you turn on your computer.
- GRUB is located at **/boot/grub/grub.conf**
- Currently we are using GRUB2 which is located at **/boot/grub2/grub.cfg**
- After getting control from MBR GRUB loads the kernel into memory and transfers control to it.

## Kernal
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

## Init
- Init is the first process that is started after the kernel is loaded.
- The process ID of INIT is 1.
- After loading itself then it loads the whole OS.
- There are several run levels in linux. Each run level has its own purpose.
- The run levels are as follows:
  - 0 - Shutdown
  - 1 - Single user mode
  - 2 - Multi user mode without networking
  - 3 - Multi user mode with networking
  - 4 - Not used
  - 5 - Multi user mode with networking and GUI
  - 6 - Reboot
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