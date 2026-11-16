.PHONY: help rf masclean

workdir     := $(shell pwd)
chroot_pkgs := live-boot linux-image-6.12.107+deb13-amd64

all:
	@echo "Use 'make help' to get started!"

help:
	@echo "Corvia Linux building guide/help:"
	@echo "WARNING: For most of the commands needs SUDO/ROOT"
	@echo " "
	@echo "(sudo) make [command]"
	@echo "      setup   | debootstraping the debian and setuping up the packages | TRIGGERS: insdeps"
	@echo "      insdeps | running the ./install_deps.sh"
	@echo "      rf      | chroot into the rootfs"
	@echo "      cleaniso| clear iso files: boot, live folder"
	@echo "      masclean| COMPLETLY ERASES THE ROOTFS | DANGER ZONE"


##              Default fully used by SETUP
insdeps:
	@./install_deps.sh || true

rf:
	@chroot $(workdir)/rootfs /bin/bash
	@umount $(workdir)/rootfs/proc || true

masclean:
	@sudo rm -rf rootfs 

cleaniso:
	@rm -f $(workdir)/iso_root/boot/{vmlinuz,initrd.img}
	@rm -f $(workdir)/iso_root/live/*
	@rm -f $(workdir)/CorviaLinux.iso


# Setup --- begin
install_pkgs:
	@chroot $(workdir)/rootfs apt install $(chroot_pkgs) -y

genInitramfs:
	@chroot $(workdir)/rootfs update-initramfs -u
setup_rootfs: insdeps
	@debootstrap --arch amd64 stable $(workdir)/rootfs http://deb.debian.org/debian/

setup: setup_rootfs install_pkgs geninitramfs
	@echo "done: setup"
# Setup --- end


genSquashfs:
	@rm -f $(workdir)/iso_root/live/filesystem.squashfs || true
	@mksquashfs $(workdir)/rootfs $(workdir)/iso_root/live/filesystem.squashfs  -comp xz 

copyBoots:
	@cp $(workdir)/rootfs/{vmlinuz,initrd.img} $(workdir)/iso_root/boot

iso: genInitramfs genSquashfs copyBoots
	grub2-mkrescue $(workdir)/iso_root -o $(workdir)/CorviaLinux.iso
