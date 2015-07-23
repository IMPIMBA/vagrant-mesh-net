#!/bin/sh
# This script installs the packets for BIRD and loads the correct configuration.

timestamp() {
  date +"%T"
}

echo "$(timestamp): Installing packages."
yum update -y
yum install -y net-tools traceroute vim

echo "$(timestamp): Turn off IP forwarding."
echo "0" > /proc/sys/net/ipv4/ip_forward

echo "$(timestamp): Installing BIRD 1.3.8."
yum install -y /vagrant/bird/bird-1.3.8-1.2.x86_64.rpm
chkconfig bird on
cp /vagrant/bird/bird.conf.OSPF /etc/bird/bird.conf

# Enable asymetric routing
# (s. https://access.redhat.com/solutions/53031 )
echo "$(timestamp): Enable asymetric routing."
echo "2" > /proc/sys/net/ipv4/conf/default/rp_filter
echo "2" > /proc/sys/net/ipv4/conf/all/rp_filter

# Turn on IP - Forward
echo "$(timestamp): Turn on IP forwarding."
echo "1" > /proc/sys/net/ipv4/ip_forward

# Turn of IPTables
echo "$(timestamp): Turn off IPTables."
chkconfig iptables off
service iptables stop

# Configuring Bird
echo "$(timestamp): Configuring and starting BIRD."
IP=$(ifconfig | sed -En 's/127\.0\.0\.1//;s/10\.[0-9]*\.[0-9]*\.[0-9]*//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | sort | head -n 1 | awk '{ print $1 }')
sed -i "s/MARKER/$IP/" /etc/bird/bird.conf
service bird start
