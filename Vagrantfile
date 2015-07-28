# -*- mode: ruby -*-
# vi: set ft=ruby :

# Requirements
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
 end

 (1..2).each do |i|
   config.vm.define "nfs#{i}" do |config|
     config.vm.network "private_network", ip: "#{conf[:ip_nfs].split(' ')[i - 1]}", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"
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
     config.vm.network "private_network", ip: "#{conf[:ip_login].split(' ')[i - 1]}", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"
     config.vm.hostname = "login#{i}"
     config.vm.box="centos6"
     config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
     config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
     config.vm.provision "shell", path: "./scripts/provision_bird.sh"
   end
 end

 nodes = 27
 base = (nodes**(1.0/3.0)).round
 servicecon_nfs = 0
 servicecon_login = 0
 if base**3 == nodes
   addresses = calculateIPs(3)
   writeIPout(addresses)
   generate_hostsfile(addresses, conf)
   nfsnodes = conf[:nodes_nfs].split(' ').map(&:to_i)
   loginnodes = conf[:nodes_login].split(' ').map(&:to_i)
   (1..nodes).each do |i|
     config.vm.define "node#{i}" do |config|
       index = (i - 1) * 6
       config.vm.network "private_network", ip: "#{addresses[(index+0)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       config.vm.network "private_network", ip: "#{addresses[(index+1)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       config.vm.network "private_network", ip: "#{addresses[(index+2)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       config.vm.network "private_network", ip: "#{addresses[(index+3)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       config.vm.network "private_network", ip: "#{addresses[(index+4)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       config.vm.network "private_network", ip: "#{addresses[(index+5)]}", netmask: "255.255.255.252", virtualbox__intnet: "inthpcnet"
       if i == nfsnodes[0] || i == nfsnodes[1]
         config.vm.network "private_network", ip: "#{conf[:ip_nfs].split(' ')[servicecon_nfs]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"
         servicecon_nfs = servicecon_nfs + 1
       end
       if i == loginnodes[0] || i == loginnodes[1]
         config.vm.network "private_network", ip: "#{conf[:ip_login].split(' ')[servicecon_login]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"
         servicecon_login = servicecon_login + 1
       end
       if i == conf[:nodes_master]
         config.vm.network "private_network", ip: "#{conf[:ip_master]}".gsub(".0.1",".0.2"), netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"#
       end
       config.vm.hostname = "node#{i}"
       config.vm.box="centos6"
       config.vm.provision "shell", path: "./scripts/provision_ssh.sh"
       config.vm.provision "shell", path: "./scripts/provision_hostsfile.sh"
       config.vm.provision "shell", path: "./scripts/provision_bird.sh"
     end
   end
 else
   STDERR.puts("ERROR: Your count of nodes hast to be an x^3 value! And was: " + base.to_s + "")
 end

 nfsclients = gen_install_template()

 config.vm.define "master1" do |config|
   config.vm.network "private_network", ip: "#{conf[:ip_master]}", netmask: "255.255.255.252", virtualbox__intnet: "intservicenet"
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
