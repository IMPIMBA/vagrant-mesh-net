require 'spec_helper'

describe 'network_hops' do
  hosttype = [ "master", "login", "nfs" ]
  it 'Check if the hops between nodes are not bigger than 4' do
    (1..27).each do |nodenr|
      host = host_inventory['hostname'][0...-1]
      cmd = "traceroute -w 1 node#{ nodenr.to_s } | grep '^\\s' | wc -l | tr -d '\\n'"
      if hosttype.include?(host)
        expect(command(cmd).stdout.to_i).to be < 6
      else
        expect(command(cmd).stdout.to_i).to be < 5
      end
    end
  end

  it 'Check if the hops to the nfs nodes are ok' do
    (1..2).each do |nodenr|
      host = host_inventory['hostname'][0...-1]
      cmd = "traceroute -w 1 nfs#{ nodenr.to_s } | grep '^\\s' | wc -l | tr -d '\\n'"
      if hosttype.include?(host)
        expect(command(cmd).stdout.to_i).to be < 6
      else
        expect(command(cmd).stdout.to_i).to be < 5
      end
    end
  end

  it 'Check if the hops to the login nodes are ok' do
    (1..2).each do |nodenr|
      host = host_inventory['hostname'][0...-1]
      cmd = "traceroute -w 1 login#{ nodenr.to_s } | grep '^\\s' | wc -l | tr -d '\\n'"
      if hosttype.include?(host)
        expect(command(cmd).stdout.to_i).to be < 6
      else
        expect(command(cmd).stdout.to_i).to be < 5
      end
    end
  end

  it 'Check if the hops to the master node is ok' do
    host = host_inventory['hostname'][0...-1]
    cmd = "traceroute -w 1 master1 | grep '^\\s' | wc -l | tr -d '\\n'"
    if hosttype.include?(host)
      expect(command(cmd).stdout.to_i).to be < 6
    else
      expect(command(cmd).stdout.to_i).to be < 5
    end
  end
end
