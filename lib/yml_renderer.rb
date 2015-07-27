# -*- mode: ruby -*-
# vi: set ft=ruby :

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
