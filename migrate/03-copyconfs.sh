
mkdir -p ./rootfs/etc/skel/.config
mkdir -p ./rootfs/etc/skel/.config/openbox

# copy openbox autostart sh
cp ./confs/openbox_autostart ./rootfs/etc/skel/.config/openbox/autostart
chmod +x ./rootfs/etc/skel/.config/openbox/autostart

# lightdm conf copy
cp ./confs/lightdm.conf ./rootfs/etc/lightdm/lightdm.conf