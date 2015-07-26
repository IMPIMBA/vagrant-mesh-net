#!/bin/sh
# This script configures paswordless ssh and installs hostfiles

# create execd local spool directory
mkdir -p /UGEexecdspool
chown -R vagrant:vagrant /UGEexecdspool

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

# TERM needs to be set for the installer
echo "export TERM=xterm" >> /root/.bashrc
echo "export TEMR=xterm" >> /home/vagrant/.bashrc

# install man page command to access UGE man pages
yum install -y man

# install libnuma.so
yum install -y numactl

# install cgroups (use when UGE version >= 8.1.7p5 is going to be installed)
yum install -y libcgroup
# make it persistent
chkconfig --level 3 cgconfig on
# enable it
service cgconfig start
