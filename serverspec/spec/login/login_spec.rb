require 'spec_helper'

describe command('source ~/.bashrc && echo $PATH') do
  its(:stdout) { should contain '/vagrant/UGE/bin/lx-amd64' }
end

cmd = "source ~/.bashrc;
       qsub -b y \"echo testdata >> /data1/testfile_$(hostname)\";
       sleep 7;
       if [ \"$(cat /data1/testfile_$(hostname))\" == \"testdata\" ]; then
          rm /data1/testfile;
          exit 0;
       else
         exit 1;
       fi"
describe command(cmd) do
  its(:exit_status) { should eq 0 }
end
