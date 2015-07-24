# -*- mode: ruby -*-
# vi: set ft=ruby :

# Temporarly requirements
require './lib/calculator'

# Generate static Hostfile for all hosts, always using 1st node ip address
def generateHostsfile(address)
  aFile = File.new("hostsfile", "w")
  if aFile
    i = 0
    while i < address.length do
      aFile.syswrite(address[i] + " " + "node" + ((i / 6) + 1).to_s + "\n")
      i = i + 6
    end
    tempLogNFSadd(aFile)
    aFile.syswrite('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' + "\n")
    aFile.syswrite('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6' + "\n")
  else
    puts "Unable to open file for writing!"
  end
end

# To make the routes to hosts a little bit better now a random number generator
# is used. To create good routes please call this method again on each
# node generation.
def generateHostsfileRandom(address)
  aFile = File.new("hostsfile", "w")
  if aFile
    i = 0
    while i < address.length do
      aFile.syswrite(address[i + rand(6)] + " " + "node" + ((i / 6) + 1).to_s + "\n")
      i = i + 6
    end
    tempLogNFSadd(aFile)
    aFile.syswrite('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' + "\n")
    aFile.syswrite('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6' + "\n")
  else
    puts "Unable to open file for writing!"
  end
end

# If you don't like the random approach, use this method a second parameter is
# added where you can add the node number and the modulo operation is used
# to determine the right ip adress for the hosts file. To create good routes
# call this method again on each node generation.
def generateHostsfileModule(address, node)
  aFile = File.new("hostsfile", "w")
  if aFile
    i = 0
    while i < address.length do
      correction = node % 6
      aFile.syswrite(address[i + correction] + " " + "node" + ((i / 6) + 1).to_s + "\n")
      i = i + 6
    end
    tempLogNFSadd(aFile)
    aFile.syswrite('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4' + "\n")
    aFile.syswrite('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6' + "\n")
  else
    puts "Unable to open file for writing!"
  end
end

# Temporarly added to make login and nfs nodes available
def tempLogNFSadd(file)
  mgmtnet = readMgmtIP()
  i = 0
  name = 1;
  for entry in mgmtnet
    if i % 2 == 0
      file.syswrite(mgmtnet[i].gsub(".0.1",".0.2") + " nfs" + name.to_s + "\n")
    else
      file.syswrite(mgmtnet[i].gsub(".0.1",".0.2") + " login" + name.to_s + "\n")
      name = name + 1
    end
    i = i + 1
  end
  file.syswrite("17.200.0.2  master1\n")
end
