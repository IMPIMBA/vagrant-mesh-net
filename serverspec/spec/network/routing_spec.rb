require 'spec_helper'

describe package('bird') do
  it { should be_installed }
end

describe service('bird') do
  it { should be_enabled   }
  it { should be_running   }
end

describe file('/etc/bird.conf') do
  it { should exist }
end
