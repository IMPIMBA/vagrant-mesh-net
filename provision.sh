#!/bin/sh


timestamp() {
  date +"%T"
}

echo "$(timestamp): Installing packages."
yum install -y net-tools

echo "$(timestamp): Setting ip forwarding."
echo "0" > /proc/sys/net/ipv4/ip_forward

echo "$(timestamp): Adding BIRD repo."

yum update
rpm -Uvh /vagrant/bird/bird-1.3.8-1.2.i686.rpm
chkconfig bird on
cp /vagrant/bird/bird.conf.OSPF /etc/bird/bird.conf


sysctl net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


chkconfig iptables off
service iptables stop

IP=$(ifconfig eth1 | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }')
sed -i "s/MARKER/$IP/" /etc/bird/bird.conf
service bird start 
