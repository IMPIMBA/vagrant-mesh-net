#!/usr/bin/env bash
# This script installs hostfiles

# configure hosts file
mv /etc/hosts /etc/hosts_orig
cat /vagrant/hostsfile > /etc/hosts
