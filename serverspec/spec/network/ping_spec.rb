require 'spec_helper'

describe 'network_ping' do
  it 'All nodes in the cluster should be reachable' do
    File.open(File.dirname(__FILE__) + "/../../../meships", "r").each_line do |line|
      ipaddress = line.scan(/\d+\.\d+\.\d+\.\d+/)
      if ipaddress != []
        expect(host(ipaddress[0])).to be_reachable
      end
    end
  end

  it 'All nfs nodes in the cluster should be reachable' do
    expect(host('17.1.0.1')).to be_reachable
    expect(host('17.2.0.1')).to be_reachable
  end

  it 'All login nodes in the cluster should be reachable' do
    expect(host('17.3.0.1')).to be_reachable
    expect(host('17.4.0.1')).to be_reachable
  end

  it 'Master nodes of cluster should be reachable' do
    expect(host('17.200.0.1')).to be_reachable
  end
end
