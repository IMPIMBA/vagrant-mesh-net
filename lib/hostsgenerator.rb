# -*- mode: ruby -*-
# vi: set ft=ruby :

# Requirements
require './lib/calculator'
require './lib/config_renderer'

# Get the cluster.yml values and execute the right method
def generate_hostsfile(address, conf)
  hostsfiles = generate_hostsfile_list(conf)
  case conf[:hostsfile_renderer]
  when "ascending"
      generate_hostsfile_ascending(address, hostsfiles)
    when "random"
      generate_hostsfile_random(address, hostsfiles)
    when "modulo"
      generate_hostsfile_modulo(address, hostsfiles, conf[:hostsfile_modul])
    else
      STDERR.puts("ERROR: Cannot read value in cluster.yml: hostsfile_renderer")
  end
end

# Checks the value in cluster.yml how much files should be generated
def generate_hostsfile_list(conf)
  hostfiles = Array[]
  case conf[:hostsfile_files]
    when "single_file"
      hostfiles.push("./hostsfile")
    when "file_per_host"
      initializeHostsfileDir()
      (1..27).each do |nodenr|
        hostfiles.push("./hostsfiles/hostsfile_node" + nodenr.to_s)
      end
      (1..2).each do |nodenr|
        hostfiles.push("./hostsfiles/hostsfile_nfs" + nodenr.to_s)
        hostfiles.push("./hostsfiles/hostsfile_login" + nodenr.to_s)
      end
      hostfiles.push("./hostsfiles/hostsfile_master1")
    else
      STDERR.puts("ERROR: Cannot read value in cluster.yml: hostsfile_files")
  end

  hostfiles
end

# Creates the individual hostfiles for the specified filename
def generate_hostsfile_ascending(address, hostsfiles)
  hostsfiles.each do |filename|
    File.open(filename, "w") do |hostsfile|
      nodenr = 1
      i = 0
      while i < address.length do
        hostsfile.puts("%s node%d" % [ address[i], nodenr ])
        i = i + 1
        if i % 6 == 0
          nodenr = nodenr + 1
        end
      end
      add_nfs_login_master(hostsfile)
      add_localhost(hostsfile)
    end
  end
end

# Write random order to specified file
def generate_hostsfile_random(address, hostsfiles)
  hostsfiles.each do |filename|
    File.open(filename, "w") do |hostsfile|
      (1..27).each do |nodenr|
        rn = rand(6)
        hostsfile.puts("%s node%d" % [ address[((nodenr - 1) * 6 ) + rn], nodenr ])
        (0..5).each do |index|
          if index != rn
            hostsfile.puts("%s node%d" % [ address[((nodenr - 1) * 6 ) + index], nodenr ])
          end
        end
      end
      add_nfs_login_master(hostsfile)
      add_localhost(hostsfile)
    end
  end
end

# If you don't like the random approach, use this method a second parameter is
# added where you can add the node number and the modulo operation is used
# to determine the right ip adress for the hosts file. To create good routes
# call this method again on each node generation.
def generate_hostsfile_modulo(address, hostsfiles, modul)
  hostsfiles.each do |filename|
    File.open(filename, "w") do |hostsfile|
      (1..27).each_with_index do |nodenr|
        correction = node % 6
        hostsfile.puts("%s node%d" % [ address[((nodenr - 1) * 6 ) + correction], nodenr ])
        (0..5).each_with_index do |index|
          if index != correction
            hostsfile.puts("%s node%d" % [ address[((nodenr - 1) * 6 ) + index], nodenr ])
          end
        end
      end
      add_nfs_login_master(hostsfile)
      add_localhost(hostsfile)
    end
  end
end

# Hostsfile
def add_localhost(hostsfile)
  hostsfile.puts('127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4')
  hostsfile.puts('::1       localhost localhost.localdomain localhost6 localhost6.localdomain6')
end

# Make login and nfs nodes available
def add_nfs_login_master(file)
  conf = read_yml_file(YAML.load_file("cluster.yml"))
  (0..1).each do |index|
    file.puts("%s nfs%d" % [ conf[:ip_nfs][index], (index + 1) ])
    file.puts("%s login%d" % [ conf[:ip_login][index], (index + 1) ])
  end
  file.puts("%s node%d" % [ conf[:ip_master][0].gsub(".0.1",".0.2"), conf[:nodes_master][0] ])
  file.puts("%s master1" % [ conf[:ip_master][0] ])
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
