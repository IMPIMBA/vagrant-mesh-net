require 'spec_helper'

describe command('echo $PATH') do
  its(:stdout) { should contain('/vagrant/UGE/bin/lx-amd64') }
end
