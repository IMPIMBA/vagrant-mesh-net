#!/usr/bin/env bash
yum update -y
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install -y gcc make gcc-c++ kernel-devel-$(uname -r) perl wget nfs-utils htop nload
reboot
