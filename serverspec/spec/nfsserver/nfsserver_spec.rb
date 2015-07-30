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
