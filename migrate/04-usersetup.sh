root_passwd="root"
liveuser_passwd="live"


chroot ./rootfs adduser --disabled-password --gecos "" liveuser

echo "root:$root_passwd" | chroot ./rootfs chpasswd
echo "liveuser:$liveuser_passwd" | chroot ./rootfs chpasswd
