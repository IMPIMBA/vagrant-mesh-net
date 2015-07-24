# -*- mode: ruby -*-
# vi: set ft=ruby :

require './lib/calculator'
require './lib/hostsgenerator'
require './lib/config_renderer'

 # Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.provider :virtualbox do |vb|
   vb.gui = false
   vb.memory = 700
   vb.cpus = 1
   vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
 end

 mgnet = readMgmtIP()

 (1..2).each_with_index do |i, index|
   config.vm.define "nfs#{i}" do |config|
     config.vm.network "private_network", ip: "#{mgnet[(index * 2)]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intmgmtnet", nic_type: "virtio"
     config.vm.hostname = "nfs#{i}"
     config.vm.box="centos6"
     config.vm.provision "shell", path: "./scripts/provision_ssh_hostsfile.sh"
     config.vm.provision "shell", path: "./scripts/provision_bird.sh"
     config.vm.provision "shell", path: "./scripts/provision_nfs_server.sh"
   end
 end

 (1..2).each_with_index do |i, index|
   config.vm.define "login#{i}" do |config|
     config.vm.network "private_network", ip: "#{mgnet[(index * 2 + 1)]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intmgmtnet", nic_type: "virtio"
     config.vm.hostname = "login#{i}"
     config.vm.box="centos6"
     config.vm.provision "shell", path: "./scripts/provision_ssh_hostsfile.sh"
     config.vm.provision "shell", path: "./scripts/provision_bird.sh"
   end
 end

 nodes = 27
 base = (nodes**(1.0/3.0)).round
 mgmcon = 0
 if base**3 == nodes
   addresses = calculateIPs(3)
   writeIPout(addresses)
   (1..nodes).each do |i|
     config.vm.define "node#{i}" do |config|
       ind = (i - 1) * 6
       generateHostsfileRandom(addresses)
       config.vm.network "private_network", ip: "#{addresses[(ind+0)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+1)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+2)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+3)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+4)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+5)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       if i == 1 || i == 9 || i == 21 || i == 25
         config.vm.network "private_network", ip: "#{mgnet[(mgmcon)]}", netmask: "255.255.255.252", virtualbox__intnet: "intmgmtnet", nic_type: "virtio"
         mgmcon = mgmcon + 1
       end
       if i == 14
         config.vm.network "private_network", ip: "17.200.0.1", netmask: "255.255.255.252", virtualbox__intnet: "intmgmtnet", nic_type: "virtio"
       end
       config.vm.hostname = "node#{i}"
       config.vm.box="centos6"
       config.vm.provision "shell", path: "./scripts/provision_ssh_hostsfile.sh"
       config.vm.provision "shell", path: "./scripts/provision_bird.sh"
     end
   end
 else
   # Do something
   STDERR.puts("ERROR: You're count of nodes hast to be an x^3 value! And was: " + base.to_s + "")
 end

 nfsclients = gen_install_template()

 config.vm.define "master1" do |config|
   config.vm.network "private_network", ip: "17.200.0.2", netmask: "255.255.255.252", virtualbox__intnet: "intmgmtnet", nic_type: "virtio"
   config.vm.hostname = "master1"
   config.vm.box="centos6"
   config.vm.provision "shell", path: "./scripts/provision_ssh_hostsfile.sh"
   config.vm.provision "shell", path: "./scripts/provision_bird.sh"
   config.vm.provision "shell", path: "./scripts/provision_nfs_clients.sh", args: nfsclients
   config.vm.provision "shell", path: "./scripts/provision_univa_grid_engine.sh"
 end
end
