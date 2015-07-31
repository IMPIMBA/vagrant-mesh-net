require 'spec_helper'

describe command('source ~/.bashrc && echo $PATH') do
  its(:stdout) { should contain '/vagrant/UGE/bin/lx-amd64' }
end

describe process("sge_qmaster") do
  it { should be_running }
end

describe port(802) do
  it { should be_listening }
end
