#!/usr/bin/env bash
# This script installs hostfiles

# configure hosts file
mv /etc/hosts /etc/hosts_orig
if [ -d "/vagrant/hostsfiles/" ]; then
  cat /vagrant/hostsfiles/hostsfile_$(hostname) > /etc/hosts
else
  cat /vagrant/hostsfile > /etc/hosts
fi
