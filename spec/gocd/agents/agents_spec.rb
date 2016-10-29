require './lib/gocd/agents/agents'
require_relative '../../../lib/gocd/agents/agents_repository'


RSpec.describe GOCD::Agents, 'agents' do

  context 'All Agents' do

    it '#idle should filter out idle agents' do
      agent1 = instance_double('agent', :idle? => true)
      agent2 = instance_double('agent', :idle? => false)
      expect(GOCD::Agents).to receive(:agents).and_return([agent1, agent2])
      expect(GOCD::Agents.idle.size).to eq 1
    end

    it '#idle should filter out missing agents' do
      agent1 = instance_double('agent', :missing? => true)
      agent2 = instance_double('agent', :missing? => false)
      expect(GOCD::Agents).to receive(:agents).and_return([agent1, agent2])
      expect(GOCD::Agents.missing.size).to eq 1
    end

    it '#idle should filter out agents in building state' do
      agent1 = instance_double('agent', :building? => true)
      agent2 = instance_double('agent', :building? => false)
      expect(GOCD::Agents).to receive(:agents).and_return([agent1, agent2])
      expect(GOCD::Agents.building.size).to eq 1
    end

    it '#idle should filter out disabled agents' do
      agent1 = instance_double('agent', :disabled? => true)
      agent2 = instance_double('agent', :disabled? => false)
      expect(GOCD::Agents).to receive(:agents).and_return([agent1, agent2])
      expect(GOCD::Agents.disabled.size).to eq 1
    end
  end
end