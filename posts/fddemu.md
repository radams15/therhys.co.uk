Title: Emulating a floppy drive with an Arduino
Tags: vintage computers, t3100e, floppy drives
Published: 29/09/2023

---
# Emulating a floppy drive with an Arduino

Recently, I've been installing a bit of software on my Toshiba t3100e. Whilst I bought *quite* a few floppy disks, it's still a hastle for me to write multiple disks for each software package.

![All my floppy disks](images/fddemu/floppies.jpg)

I've known about the [FloppyEmu](https://www.bigmessowires.com/floppy-emu/) for a while, but at over £100 it was a bit more than I could afford.

Whilst looking for alternatives, I stumbled across [FDDEmu](https://github.com/acemielektron/fddEMU), which allowed me to emulate a (slightly slow) floppy drive with my existing Arduino uno.

Because I was feeling cheap, I didn't opt for the optional OLED screen, but instead enabled serial mode to control the emulator via another computer over USB.

Instead of wiring up the emulator into the internal floppy header of the t3100e, I opted to use the external floppy drive port which is included in this model. This enables one to use the parallel port as a floppy drive port, with the following pinout:


    PIN  Input/Output   Signal

    1       I       Drive Ready
    2       I       Index
    3       I       Track 0
    4       I       Write Protect
    5       I       Read Data
    6       I       Disk Change (All Toshiba computers except T1000, T1100 Plus, T1200)
    7-9             not used
    10      O       Drive Select
    11      O       Motor On
    12      O       Write Data
    13      O       Write Gate
    14      O       Low Density (All Toshiba computers except T1000, T1100 Plus, T1200)
    15      O       Side Select
    16      O       Direction
    17      O       Step
    18-25           Signal Ground
            (T1000 MUST have pins 24 and 25 grounded)

I wired the Arduino as specified by the FDDEmu Github repo to a DB-25 breakout board and plugged it into the parallel port of the t3100e, making sure to select "A" on the port switcher switch on the side of the machine. This ensures the emulator is drive A and the internal drive is B.

![The device connected to the t3100e](images/fddemu/wired.jpg)

I copied an image of a floppy of MS-DOS 6.22 onto the sd-card as "boot.img", and the 3 5&#188;" floppies for the Windows 286 installed onto the SD card, and booted. This allowed me to install a fresh copy of DOS 6.22 and Windows 286 onto my machine, all from an SD card.

Connecting over serial allows one to switch the virtual drive between the disk images on the root of the SD card through a simple to use interface:

![The serial interface](images/fddemu/serial_log.png)

Here is an example of booting RhysOS, then listing the directory in DOS after changing the drive from A to B:

![Booting RhysOS](images/fddemu/rhysos.jpg)

![Listing RhysOS in DOS](images/fddemu/dir_rhysos.jpg)

All together, this emulator only cost around £20, with the Arduino itself costing £10 of that, which is a large saving over the Floppy Emu.
