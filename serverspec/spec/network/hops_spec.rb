require 'spec_helper'

describe 'network_hops' do
  it 'Check if the hops between nodes are not bigger than 4' do
    command('sudo hopcounter node1') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node2') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node3') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node4') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node5') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node6') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node7') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node8') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node9') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node10') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node11') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node12') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node13') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node14') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node15') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node16') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node17') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node18') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node19') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node20') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node21') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node22') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node23') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node24') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node25') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node26') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
    command('sudo hopcounter node27') do
      expect(subject.exit_status).to be_within(2).of(2)
    end
  end

  it 'Check if the hops to the login nodes are ok' do
    command('sudo hopcounter login1') do
      expect(subject.exit_status).to be_within(3).of(3)
    end
    command('sudo hopcounter login2') do
      expect(subject.exit_status).to be_within(3).of(3)
    end
  end

  it 'Check if the hops to the nfs nodes are ok' do
    command('sudo hopcounter nfs1') do
      expect(subject.exit_status).to be_within(3).of(3)
    end
    command('sudo hopcounter nfs2') do
      expect(subject.exit_status).to be_within(3).of(3)
    end
  end

  it 'Check if the hops to the master node is ok' do
    command('sudo hopcounter master1') do
      expect(subject.exit_status).to be_within(3).of(3)
    end
  end
end
