# -*- mode: ruby -*-
# vi: set ft=ruby :

# Temporarly requirements
require './lib/calculator'

# Generate static Hostfile for all hosts, always using ipaddresses in input
# order
def generateHostsfile(address)
  generateHostsfileWriter(address, "./hostsfile")
end

# Generate an individual hostfile for all hosts, always using ipaddresses
# in input order
def generateHostsfileEach(address)
  initializeHostsfileDir()
  (1..27).each do |nodenr|
    generateHostsfileWriter(address, "./hostsfiles/hostsfile_node" + nodenr.to_s)
  end
  (1..2).each do |nodenr|
    generateHostsfileWriter(address, "./hostsfiles/hostsfile_nfs" + nodenr.to_s)
    generateHostsfileWriter(address, "./hostsfiles/hostsfile_login" + nodenr.to_s)
  end
  generateHostsfileWriter(address, "./hostsfiles/hostsfile_master1")
end

# Creates the individual hostfiles for the specified filename
def generateHostsfileWriter(address, filename)
  File.open(filename, "w") do |hostsfile|
    nodenr = 1
    i = 0
    while i < address.length do
      hostsfile.puts("%s node%d", [ address[i], nodenr ])
      i = i + 1
      if i % 6 == 0
        nodenr = nodenr + 1
      end
    end
    tempLogNFSadd(hostsfile)
    hostsfile.puts('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4')
    hostsfile.puts('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6')
  end
end

# To make the routes to hosts a little bit better now a random number generator
# is used.
def generateHostsfileRandom(address)
  generateHostsfileRandomWriter(address, "./hostsfile")
end

# Generate an individual hostfile for all hosts, using ipaddresses
# in a random order
def generateHostsfileRandomEach(address)
  initializeHostsfileDir()
  (1..27).each do |nodenr|
    generateHostsfileRandomWriter(address, "./hostsfiles/hostsfile_node" + nodenr.to_s)
  end
  (1..2).each do |nodenr|
    generateHostsfileRandomWriter(address, "./hostsfiles/hostsfile_nfs" + nodenr.to_s)
    generateHostsfileRandomWriter(address, "./hostsfiles/hostsfile_login" + nodenr.to_s)
  end
  generateHostsfileRandomWriter(address, "./hostsfiles/hostsfile_master1")
end

# Write random order to specified file
def generateHostsfileRandomWriter(address, filename)
  File.open(filename, "w") do |hostsfile|
    (1..27).each do |nodenr|
      rn = rand(6)
      hostsfile.puts("%s node%d", [ address[((nodenr - 1) * 6 ) + rn], nodenr ])
      (0..5).each do |index|
        if index != rn
          hostsfile.puts("%s node%d", [ address[((nodenr - 1) * 6 ) + index], nodenr ])
        end
      end
    end
    tempLogNFSadd(hostsfile)
    hostsfile.puts('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' + "\n")
    hostsfile.puts('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6' + "\n")
  end
end

# If you don't like the random approach, use this method a second parameter is
# added where you can add the node number and the modulo operation is used
# to determine the right ip adress for the hosts file. To create good routes
# call this method again on each node generation.
def generateHostsfileModul(address, node)
  generateHostsfileModulWriter(address, node, "./hostsfile")
end

# Generate an individual hostfile for all hosts, using ipaddresses
# in the specified order
def generateHostsfileModulEach(address, node)
  initializeHostsfileDir()
  (1..27).each do |nodenr|
    generateHostsfileModulWriter(address, "./hostsfiles/hostsfile_node" + nodenr.to_s)
  end
  (1..2).each do |nodenr|
    generateHostsfileModulWriter(address, "./hostsfiles/hostsfile_nfs" + nodenr.to_s)
    generateHostsfileModulWriter(address, "./hostsfiles/hostsfile_login" + nodenr.to_s)
  end
  generateHostsfileModulWriter(address, "./hostsfiles/hostsfile_master1")
end

# Write random order to specified file
def generateHostsfileModulWriter(address, node, filename)
  File.open(filename, "w") do |hostsfile|
    i = 0
    (1..27).each_with_index do |nodenr|
      correction = node % 6
      hostsfile.puts("%s node%d", [ address[((nodenr - 1) * 6 ) + correction], nodenr ])
      (0..5).each_with_index do |index|
        if index != correction
          hostsfile.puts("%s node%d", [ address[((nodenr - 1) * 6 ) + index], nodenr ])
        end
      end
    end
    tempLogNFSadd(hostsfile)
    hostsfile.puts('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' + "\n")
    hostsfile.puts('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6' + "\n")
  end
end

# Check if hostsdirectory exists and clear it for the hostfiles
def initializeHostsfileDir()
  if(File.directory?("./hostsfiles"))
    mkdir("./hostsfiles")
  else
    for path in Dir["./hostsfiles/*"]
      File.delete(path)
    end
  end
end

# Temporarly added to make login and nfs nodes available
def tempLogNFSadd(file)
  mgmtnet = getServiceNodeIPs()
  i = 0
  nodenr = 1;
  for entry in mgmtnet
    if i % 2 == 0
      file.puts("%s nfs%d", [ mgmtnet[i].gsub(".0.1",".0.2"), nodenr ])
    else
      file.puts("%s login%d", [ mgmtnet[i].gsub(".0.1",".0.2"), nodenr ])
      nodenr = nodenr + 1
    end
    i = i + 1
  end
  file.puts("17.200.0.1 node14\n")
  file.puts("17.200.0.2 master1\n")
end
