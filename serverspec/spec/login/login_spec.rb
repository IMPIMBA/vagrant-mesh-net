require 'spec_helper'

describe file('/root/.bashrc') do
  it { should contain 'source /vagrant/UGE/default/common/settings.sh' }
end

describe file('/home/vagrant/.bashrc') do
  it { should contain 'source /vagrant/UGE/default/common/settings.sh' }
end
