# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'erb'

def gen_install_template()
  aFile = File.new("auto_install_template", "w")
  nodes = ""
  adminlist = ""
  submitlist = ""
  execlist = ""

  adminlist = "master1 login1 login2"
  submitlist = "login1 login2 "

  (1..27).each do |i|
    execlist = execlist + "node" + i.to_s + " "
  end

  nodes = adminlist + " " + execlist

  template = ERB.new(File.read("lib/auto_install_template"))
  aFile.syswrite(template.result(binding))

  return nodes
end
