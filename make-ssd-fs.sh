#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root (e.g. sudo $0)"
    exit
fi

DEVICES="`ls /dev/xvd* |grep -v xvda`"
if [ "$DEVICES" == "" ]; then
    echo "No secondary storage to configure."
    exit
fi

if [ "$DEVICES" == "/dev/xvdb" ]; then
    echo "Using secondary storage $DEVICES as-is."
    exit
fi

# pre-requisites
apt-get update
apt-get -y --no-install-recommends install mdadm

# un-use devices
umount /dev/xvdb
umount /dev/xvdc
umount /dev/md0
mdadm --stop /dev/md0
mdadm --remove /dev/md0
sed -i "\@^/dev/xvdb@d" /etc/fstab
sed -i "\@^/dev/md@d" /etc/fstab
echo '' > /etc/mdadm/mdadm.conf

# create raid0
mdadm --zero-superblock /dev/xvdb
mdadm --zero-superblock /dev/xvdc
yes | mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/xvdb /dev/xvdc
sleep 10
if [ "`grep 'md0 : active' /proc/mdstat`" == "" ]; then
echo "error: cat /proc/mdstat shows raid is not active"
exit 1
fi
mkfs.ext4 -F /dev/md0
mount /dev/md0 /mnt
mdadm --detail --scan > /etc/mdadm/mdadm.conf
echo '/dev/md0 /mnt ext4 defaults,nofail,noatime,nodiratime,discard 0 0' >> /etc/fstab
update-initramfs -u
