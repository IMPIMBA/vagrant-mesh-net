#!/usr/bin/env bash
yum install -y kernel-devel-$(uname -r)
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run
umount /mnt
rm -rf /home/vagrant/VBoxGuestAdditions_*.iso
