# -*- mode: ruby -*-
# vi: set ft=ruby :

 # Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.provider :virtualbox do |vb|
   vb.gui = true
   vb.memory = 256
   vb.cpus = 1
 end

 nodes = 4
 (1..nodes).each do |i|
    config.vm.define "node-#{i}" do |config|
     case i
     when 1
       config.vm.network "private_network", ip: "17.0.#{1}.#{1}", virtualbox__intnet: "node#{1}-to-node#{nodes}"
       config.vm.network "private_network", ip: "17.0.#{(i+1)}.#{1}", virtualbox__intnet: "node#{1}-to-node#{(i+1)}"
     when nodes
       config.vm.network "private_network", ip: "17.0.#{(i)}.#{2}", virtualbox__intnet: "node#{(i-1)}-to-node#{i}"
       config.vm.network "private_network", ip: "17.0.#{(1)}.#{2}", virtualbox__intnet: "node#{1}-to-node#{nodes}"
     else
       config.vm.network "private_network", ip: "17.0.#{(i)}.#{(2)}", virtualbox__intnet: "node#{(i-1)}-to-node#{i}"
       config.vm.network "private_network", ip: "17.0.#{(i+1)}.#{(1)}", virtualbox__intnet: "node#{i}-to-node#{(i+1)}"
     end
    config.vm.hostname = "node-#{i}"
    config.vm.box="cent7"
    config.vm.provision "shell", path: "provision.sh"
    end
  end
end
