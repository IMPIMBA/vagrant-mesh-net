require 'spec_helper'

describe command('source ~/.bashrc && echo $PATH') do
  its(:stdout) { should contain '/vagrant/UGE/bin/lx-amd64' }
end


name = host_inventory['hostname'].chars.last
cmd = "source ~/.bashrc && qsub -b y \"echo testdata >> /data#{name}/testfile\""
describe command(cmd) do
  its(:stdout) { should contain 'has been submitted' }
end

describe command('sleep 5') do
  its(:exit_status) { should eq 0 }
end

cmd = "/data#{name}/testfile"
describe file(cmd) do
  it { should exist }
end

cmd = "rm -f " + cmd
describe command(cmd) do
  its(:exit_status) { should eq 0 }
end
