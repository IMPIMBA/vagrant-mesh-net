# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'

def gen_install_template()
  nodes = Array[]
  adminl = Array[]
  submitl = Array[]
  execl = Array[]

  adminl.push("master1")
  adminl.push("login1")
  adminl.push("login2")

  submitl.push("login1")
  submitl.push("login2")

  (1..27).each do |i|
    execl.push("node" + i.to_s)
  end

  File.open("auto_install_template", "w") do |auto_install_template|
    adminlist = adminl.join(' ')
    submitlist = submitl.join(' ')
    execlist = execl.join(' ')
    template = ERB.new(File.read("lib/auto_install_template.erb"))
    auto_install_template.write(template.result(binding))
  end

  nodes = adminl.join(' ') + " " + execl.join(' ')

  nodes
end
