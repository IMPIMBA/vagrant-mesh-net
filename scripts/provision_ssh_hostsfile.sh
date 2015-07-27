#!/usr/bin/env bash
# This script configures paswordless ssh and installs hostfiles

# configure passwordless ssh
sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant chmod 700 /home/vagrant/.ssh
sudo -u vagrant cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
sudo -u vagrant chmod 600 /home/vagrant/.ssh/id_rsa
sudo -u vagrant cat /vagrant/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
sudo -u vagrant chmod 600 /home/vagrant/.ssh/authorized_keys
cat << EOT > /home/vagrant/.ssh/config
host *
    StrictHostKeyChecking no
EOT
chown vagrant /home/vagrant/.ssh/config

sudo -u root mkdir -p /root/.ssh
sudo -u root chmod 700 /root/.ssh
sudo -u root cp /vagrant/id_rsa /root/.ssh/id_rsa
sudo -u root chmod 600 /root/.ssh/id_rsa
sudo -u root cat /vagrant/id_rsa.pub >> /root/.ssh/authorized_keys
sudo -u root chmod 600 /root/.ssh/authorized_keys
cat << EOT > /root/.ssh/config
host *
    StrictHostKeyChecking no
EOT
chown root /root/.ssh/config

# configure hosts file
mv /etc/hosts /etc/hosts_orig
cat /vagrant/hostsfile > /etc/hosts
