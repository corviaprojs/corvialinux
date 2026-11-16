root_passwd="root"
liveuser_passwd="live"


adduser --disabled-password liveuser

chroot ./rootfs (echo "$root_passwd" | passwd -s root)
chroot ./rootfs (echo "$liveuser_passwd" | passwd -s liveuser)