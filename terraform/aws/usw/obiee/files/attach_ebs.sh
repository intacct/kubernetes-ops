#!/bin/bash
mkfs -t xfs /dev/nvme1n1
mkdir /u01
mount /dev/nvme1n1 /u01
echo /dev/nvme1n1  /u01 xfs defaults,nofail 0 2 >> /etc/fstab

mkfs -t xfs /dev/nvme2n1
mkdir /u02
mount /dev/nvme2n1 /u02
echo /dev/nvme2n1 /u02 xfs defaults,nofail 0 2 >> /etc/fstab

dd if=/dev/zero of=/u02/swapfile bs=128M count=8
chmod 0600 /u02/swapfile
mkswap /u02/swapfile
swapon -a
echo /u02/swapfile swap swap defaults  0 2 >> /etc/fstab

