.PHONY: chroot masclean isoclean install_pkgs setup_rootfs genInitramfs genSquashfs copyBoots

workdir       := $(shell pwd)

# packages thats gets installed on the rootfs
chroot_pkgs := live-boot \
	linux-image-6.12.107+deb13-amd64 \
	lightdm \
	openbox \
	locales \
	network-manager \
	xorg \
	obconf

GRUB_MKRESCUE := $(shell command -v grub2-mkrescue 2>/dev/null || echo grub-mkrescue)	

migrate_files := $(wildcard $(workdir)/migrate/*)

iso_name := simpleLinux.iso

all:
	@echo "Check the README.md! To get started!"

chroot:
	@chroot $(workdir)/rootfs /bin/bash
	@umount $(workdir)/rootfs/proc || true

masclean:
	@sudo rm -rf rootfs 

isoclean:
	@rm -f $(workdir)/iso_root/boot/{vmlinuz,initrd.img}
	@rm -f $(workdir)/iso_root/live/*
	@rm -f $(workdir)/$(iso_name)

# Setup --- begin
install_pkgs:
	@chroot $(workdir)/rootfs apt install --no-install-recommends $(chroot_pkgs) -y 2>/dev/null
setup_rootfs: 
	@debootstrap --arch amd64 stable $(workdir)/rootfs http://deb.debian.org/debian/ 2>/dev/null

setup: setup_rootfs install_pkgs
	@mkdir $(workdir)/iso_root/live/
	@echo "done: setup"
# Setup --- end

migrate:
	@for file in $(migrate_files); do \
		echo "Applying: $$file..."; \
		chmod +x $$file; \
		$$file; \
	done

# iso building:

genInitramfs:
	@chroot $(workdir)/rootfs update-initramfs -u 2>/dev/null

genSquashfs:
	@rm -f $(workdir)/iso_root/live/filesystem.squashfs || true
	@mksquashfs $(workdir)/rootfs $(workdir)/iso_root/live/filesystem.squashfs -comp xz

copyBoots:
	@cp $(workdir)/rootfs/vmlinuz $(workdir)/iso_root/boot
	@cp $(workdir)/rootfs/initrd.img $(workdir)/iso_root/boot

iso: genInitramfs genSquashfs copyBoots
	@$(GRUB_MKRESCUE) $(workdir)/iso_root -o $(workdir)/$(iso_name)
	@echo "Your iso is done: $(workdir)/$(iso_name)"