require 'spec_helper'

describe service('rpcbind') do
  it { should be_enabled }
  it { should be_running }
end

describe service ('nfs') do
  it { should be_running }
end

describe port(111) do
  it { should be_listening }
end

describe file('/etc/exports') do
  name = host_inventory['hostname'].chars.last
  it { should contain "/data#{name} 17.0.0.0/8(rw,async,no_root_squash,no_subtree_check)" }
end
