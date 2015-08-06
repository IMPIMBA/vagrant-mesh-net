require_relative 'spec_helper'

describe 'box' do
  it 'should have a root user' do
    expect(user 'root').to exist
  end

  it 'should have a vagrant user' do
    expect(user 'vagrant').to exist
  end

  it 'should have a vagrant user' do
    expect(user 'vagrant').to exist
  end

  it 'should have a .vbox_version file' do
    expect(file '/home/vagrant/.vbox_version').to be_file
  end

  it 'should disable SELinux' do
    expect(selinux).to be_disabled
  end

  it 'should have EPEL installed and enabled' do
    expect(yumrepo('epel')).to exist
    expect(yumrepo('epel')).to be_enabled
  end

  it 'should have base packeges installed' do
    expect(package('gcc')).to be_installed
    expect(package('make')).to be_installed
    expect(package('gcc-c++')).to be_installed
    expect(package('perl')).to be_installed
    expect(package('wget')).to be_installed
    expect(package('nfs-utils')).to be_installed
    expect(package('htop')).to be_installed
    expect(package('nload')).to be_installed
    expect(package('iperf3')).to be_installed
    expect(package('iotop')).to be_installed
    expect(package('net-tools')).to be_installed
    expect(package('traceroute')).to be_installed
    expect(package('vim')).to be_installed
  end

  it 'should have vagrant ssh key installed and set correctly' do
    expect(file('/home/vagrant/.ssh/authorized_keys')).to exist
    expect(file('/home/vagrant/.ssh/authorized_keys')).to be_mode(600)
    expect(file('/home/vagrant/.ssh/authorized_keys')).to be_owned_by 'vagrant'
  end

  it 'VBOX Additions should be installed' do
    expect(service('vboxadd')).to be_enabled
    expect(service('vboxadd')).to be_running
    expect(service('vboxadd-service')).to be_enabled
    expect(service('vboxadd-service')).to be_running
  end

  it 'Hopscounter installed' do
    expect(file('/usr/bin/hopcounter')).to exist
    expect(file('/usr/bin/hopcounter')).to be_mode(755)
    expect(file('/usr/bin/hopcounter')).to be_owned_by 'root'
  end

end
