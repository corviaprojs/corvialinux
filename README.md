# SimpleLinux

A fast, opensource linux.
Purpose:
    - Learning how a custom linux get built.
    - It be simple customizable and configurable.

A migrate system thats gets executed for enableing, setuping up setting such as user configuration.
Building Dependecy installer script: a simple shell script that installs the required packages to build down simple linux.

### Getting Started

Help is avalible with: 'sudo make help' also.
1. Setuping up:
`sudo make setup`
    - Its creates a standard debian stable version debootstrap.
    - Installs live-boot and openbox etc...(its definied in Makefile)

2. Applying migrate scripts:
`sudo make migrate`
    - Runs down the shell scripts in the migrate folder based on the number its has: '01-hostname.sh' <- runs first.

3. Building ISO:
`sudo make iso`
    - Manually forces initramfs regeneration
    - Its squashfs's the rootfs(debian debootstrap)
    - Packs it with grub(2)-mkrescue with the iso_root/boot/grub/grub.cfg config file

You have your builded iso in the root.

### More commands:
`sudo make chroot`
    - Chroot's into the existing rootfs with /bin/bash

`sudo make masclean`
    - REMOVES THE ROOTFS (Use at your own risk!)

`sudo make isoclean`
    - Clears out the iso_root folder