#!/usr/bin/env bash
yum update -y
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install -y gcc make gcc-c++ perl wget nfs-utils htop nload iperf3 iotop net-tools traceroute vim
reboot
