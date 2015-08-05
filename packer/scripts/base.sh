#!/usr/bin/env bash
yum update -y
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install -y gcc make gcc-c++ perl wget nfs-utils htop nload iperf3 iotop
mv /tmp/hopscounter /usr/bin/hopscounter
chown root: /usr/bin/hopscounter
chmod 755 /usr/bin/hopscounter
reboot
