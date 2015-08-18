#!/usr/bin/env bash
# This script configures paswordless ssh

# configure passwordless ssh
sudo -u vagrant mkdir -p /home/vagrant/.ssh
sudo -u vagrant chmod 700 /home/vagrant/.ssh
sudo -u vagrant cp /vagrant/id_rsa /home/vagrant/.ssh/id_rsa
sudo -u vagrant chmod 600 /home/vagrant/.ssh/id_rsa
cat /vagrant/id_rsa.pub | sudo -u vagrant tee -a /home/vagrant/.ssh/authorized_keys > /dev/null
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
cat /vagrant/id_rsa.pub | sudo -u root tee -a /root/.ssh/authorized_keys > /dev/null
sudo -u root chmod 600 /root/.ssh/authorized_keys
cat << EOT > /root/.ssh/config
host *
    StrictHostKeyChecking no
EOT
chown root /root/.ssh/config
