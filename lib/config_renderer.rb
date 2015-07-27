# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'

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
