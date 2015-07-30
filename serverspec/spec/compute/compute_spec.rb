require 'spec_helper'

describe process("sge_execd") do
  it { should be_running }
end

describe port(803) do
  it { should be_listening}
end
