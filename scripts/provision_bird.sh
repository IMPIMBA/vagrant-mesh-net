#!/usr/bin/env bash
# This script installs the packets for BIRD and loads the correct configuration.

timestamp() {
  date +"%T"
}

echo "$(timestamp): Updateing packages."
yum update -y

echo "$(timestamp): Turn off IP forwarding."
echo "0" > /proc/sys/net/ipv4/ip_forward

echo "$(timestamp): Installing BIRD"
yum install -y bird
chkconfig bird on
cp /vagrant/bird.conf.OSPF /etc/bird.conf

# Enable asymetric routing
# (s. https://access.redhat.com/solutions/53031 )
echo "$(timestamp): Enable asymmetric routing."
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
sed -i "s/MARKER/$IP/" /etc/bird.conf
service bird start
