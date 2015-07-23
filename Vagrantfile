# -*- mode: ruby -*-
# vi: set ft=ruby :

require './lib/calculator'

 # Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.provider :virtualbox do |vb|
   vb.gui = false
   vb.memory = 225
   vb.cpus = 1
   vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
 end

 nodes = 27
 base = (nodes**(1.0/3.0)).round
 if base**3 == nodes
   addresses = calculateIPs(3)
   (1..nodes).each do |i|
     config.vm.define "node#{i}" do |config|
       ind = (i - 1) * 6
       config.vm.network "private_network", ip: "#{addresses[(ind+0)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+1)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+2)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+3)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+4)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(ind+5)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.hostname = "node#{i}"
       config.vm.box="centos6"
       config.vm.provision "shell", path: "./scripts/provision.sh"
     end
   end
 else
   # Do something
   STDERR.puts("ERROR: You're count of nodes hast to be an x^3 value! And was: " + base.to_s + "")
 end
end
