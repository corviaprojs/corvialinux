# setting the 'en_US' charset and lang to generate
echo "en_US.UTF-8 UTF-8" >> ./rootfs/etc/locale.gen

# generating the definied charsets
chroot ./rootfs locale-gen
chroot ./rootfs update-locale LANG=en_US.UTF-8