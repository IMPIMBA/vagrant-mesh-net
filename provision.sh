#!/bin/sh


timestamp() {
  date +"%T"
}

echo "$(timestamp): Installing packages."
yum install -y net-tools

echo "$(timestamp): Enabling ip forwarding."
echo "1" > /proc/sys/net/ipv4/ip_forward
