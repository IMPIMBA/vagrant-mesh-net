# -*- mode: ruby -*-
# vi: set ft=ruby :

require './lib/calculator'
require './lib/hostsgenerator'
require './lib/config_renderer'

base_dir = File.expand_path(File.dirname(__FILE__))
conf = read_yml_file(YAML.load_file(File.join(base_dir, "cluster.yml")))
gen_bird_template(conf)

 # Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 config.vm.provider :virtualbox do |vb|
   vb.gui = false
   vb.memory = conf[:vm_mem]
   vb.cpus = conf[:vm_cpus]
   vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
 end

 servicenet = getServiceNodeIPs()

 (1..2).each_with_index do |i, index|
   config.vm.define "nfs#{i}" do |config|
     config.vm.network "private_network", ip: "#{servicenet[(index * 2)]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intservicenet", nic_type: "virtio"
     config.vm.hostname = "nfs#{i}"
     config.vm.box="centos6"
     config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
     config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
     config.vm.provision "shell", path: "./scripts/provision_bird.sh"
     config.vm.provision "shell", path: "./scripts/provision_nfs_server.sh"
   end
 end

 (1..2).each_with_index do |i, index|
   config.vm.define "login#{i}" do |config|
     config.vm.network "private_network", ip: "#{servicenet[(index * 2 + 1)]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intservicenet", nic_type: "virtio"
     config.vm.hostname = "login#{i}"
     config.vm.box="centos6"
     config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
     config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
     config.vm.provision "shell", path: "./scripts/provision_bird.sh"
   end
 end

 nodes = 27
 base = (nodes**(1.0/3.0)).round
 servicecon = 0
 if base**3 == nodes
   addresses = calculateIPs(3)
   writeIPout(addresses)
   nfsnodes = conf[:nodes_nfs].split(' ').map(&:to_i)
   loginnodes = conf[:nodes_login].split(' ').map(&:to_i)
   (1..nodes).each do |i|
     config.vm.define "node#{i}" do |config|
       index = (i - 1) * 6
       generateHostsfile(addresses)
       config.vm.network "private_network", ip: "#{addresses[(index+0)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(index+1)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(index+2)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(index+3)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(index+4)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       config.vm.network "private_network", ip: "#{addresses[(index+5)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet", nic_type: "virtio"
       if i == nfsnodes[0] || i == nfsnodes[1] || i == loginnodes[0] || i == loginnodes[1]
         config.vm.network "private_network", ip: "#{servicenet[(servicecon)]}", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet", nic_type: "virtio"
         servicecon = servicecon + 1
       end
       if i == conf[:nodes_master]
         config.vm.network "private_network", ip: "17.200.0.1", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet", nic_type: "virtio"
       end
       config.vm.hostname = "node#{i}"
       config.vm.box="centos6"
       config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
       config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
       config.vm.provision "shell", path: "./scripts/provision_bird.sh"
     end
   end
 else
   # Do something
   STDERR.puts("ERROR: Your count of nodes hast to be an x^3 value! And was: " + base.to_s + "")
 end

 nfsclients = gen_install_template()

 config.vm.define "master1" do |config|
   config.vm.network "private_network", ip: "17.200.0.2", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet", nic_type: "virtio"
   config.vm.hostname = "master1"
   config.vm.box="centos6"
   config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
   config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
   config.vm.provision "shell", path: "./scripts/provision_bird.sh"
   config.vm.provision "shell", path: "./scripts/provision_nfs_clients.sh", args: nfsclients
   config.vm.provision "shell", path: "./scripts/provision_openmpi.sh"
   config.vm.provision "shell", path: "./scripts/provision_univa_grid_engine.sh"
 end
end
