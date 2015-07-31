require 'spec_helper'

describe file('/root/.bashrc') do
  it { should contain 'source /vagrant/UGE/default/common/settings.sh' }
end

describe file('/home/vagrant/.bashrc') do
  it { should contain 'source /vagrant/UGE/default/common/settings.sh' }
end

describe process("sge_qmaster") do
  it { should be_running }
end

describe port(802) do
  it { should be_listening }
end
