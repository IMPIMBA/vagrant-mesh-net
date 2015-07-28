# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'
require 'yaml'

# Create the Bird Config Template to deploy on nodes
def gen_bird_template(conf)
  File.open("./bird/bird.conf.OSPF", "w") do |bird_config|
    template = ERB.new(File.read("lib/bird.conf.OSPF.erb"))
    bird_config.write(template.result(binding))
  end
end

# Generate the auto_install_template for UGE
def gen_install_template()
  adminlist = Array[]
  submitlist = Array[]
  execlist = Array[]

  adminlist.push("master1")
  adminlist.push("login1")
  adminlist.push("login2")

  submitlist.push("login1")
  submitlist.push("login2")

  (1..27).each do |i|
    execlist.push("node" + i.to_s)
  end

  File.open("auto_install_template", "w") do |auto_install_template|
    template = ERB.new(File.read("lib/auto_install_template.erb"))
    auto_install_template.write(template.result(binding))
  end

  nodes = adminlist.join(' ') + " " + execlist.join(' ')

  nodes
end

def read_yml_file(cluster_yml)
  vm_cpus = cluster_yml['vm_cpus']
  vm_mem = cluster_yml['vm_mem']

  ospf_scan_time = cluster_yml['scan_time']
  ospf_hello = cluster_yml['hello']
  ospf_dead_count = cluster_yml['dead_count']
  ospf_metricX = cluster_yml['metricX']
  ospf_metricY = cluster_yml['metricY']
  ospf_metricZ = cluster_yml['metricZ']
  ospf_area = cluster_yml['OSFP_Area']
  ospf_networks = cluster_yml['networks']

  nodes_nfs = cluster_yml['nfs']
  nodes_login = cluster_yml['login']
  nodes_master = cluster_yml['master']

  { :vm_cpus =>  vm_cpus, :vm_mem => vm_mem, :ospf_scan_time => ospf_scan_time,
    :ospf_hello => ospf_hello, :ospf_dead_count => ospf_dead_count,
    :ospf_metricX => ospf_metricX, :ospf_metricY => ospf_metricY,
    :ospf_metricZ => ospf_metricZ, :ospf_area => ospf_area, :ospf_networks => ospf_networks,
    :nodes_nfs => nodes_nfs, :nodes_login => nodes_login, :nodes_master => nodes_master }
end
