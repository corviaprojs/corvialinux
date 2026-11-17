root_passwd="root"
liveuser_passwd="live"

#'liveuser' user createing
chroot ./rootfs adduser --disabled-password --gecos "" liveuser

# setting the 'root' and 'liveuser' password
echo "root:$root_passwd" | chroot ./rootfs chpasswd
echo "liveuser:$liveuser_passwd" | chroot ./rootfs chpasswd

#adding 'sudo' group to 'liveuser'
chroot ./rootfs usermod -aG sudo liveuser