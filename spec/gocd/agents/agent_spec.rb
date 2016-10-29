require './lib/gocd/agents/agent'

RSpec.describe GOCD::Agent, 'agent' do

  agent_response = {
      'hostname' => 'agent 1',
      'uuid' => '1a2s3d4f',
      'operating_system' => 'Linux',
      'free_space' => 76202504192,
      'agent_state' => 'Idle',
      'resources' => %w(java automation),
      'environments' => %w(iOS android),
      'sandbox' => '/Applications/GoAgent.app',
      'agent_config_state' => 'Disabled',
      'ip_address' => '10.0.0.1'
  }

  context 'agent getters' do
    before(:each) do
      @agent = GOCD::Agent.new agent_response
    end

    it '#name should return agent name' do
      expect(@agent.name).to eq 'agent 1'
    end

    it '#uuid should return agent uuid' do
      expect(@agent.uuid).to eq '1a2s3d4f'
    end

    it '#os should return agent operating system' do
      expect(@agent.os).to eq 'Linux'
    end

    it '#free_space should return free space on agent' do
      expect(@agent.free_space).to eq 76202504192
    end

    it '#state should return agent state' do
      expect(@agent.state).to eq 'Idle'
    end

    it '#resources should return agent resources' do
      expect(@agent.resources).to eq %w(java automation)
    end

    it '#has_resource should return true when agent has given resource' do
      expect(@agent.has_resource 'java').to be_truthy
    end

    it '#has_resource should return false when agent does not have given resource' do
      expect(@agent.has_resource 'abcd').to be_falsy
    end

    it '#environments should return agent environments' do
      expect(@agent.environments).to eq %w(iOS android)
    end

    it '#has_environment should return true when agent has given environment' do
      expect(@agent.has_environment 'iOS').to be_truthy
    end

    it '#has_environment should return false when agent does not have given environment' do
      expect(@agent.has_environment 'abcd').to be_falsy
    end

    it '#location should return agent sandbox location' do
      expect(@agent.location).to eq '/Applications/GoAgent.app'
    end

    it '#idle? should return true when agent is Idle' do
      expect(@agent.idle?).to be_truthy
    end

    it '#building? should return true when agent is Building' do
      agent_response['agent_state'] = 'Building'
      @agent = GOCD::Agent.new agent_response
      expect(@agent.building?).to be_truthy
    end

    it '#missing? should return true when agent is Missing' do
      agent_response['agent_state'] = 'Missing'
      @agent = GOCD::Agent.new agent_response
      expect(@agent.missing?).to be_truthy
    end

    it '#disabled? should return true when agent is disabled' do
      expect(@agent.disabled?).to be_truthy
    end

    it '#disabled? should return false when agent is not disabled' do
      agent_response['agent_config_state'] = 'Running'
      @agent = GOCD::Agent.new agent_response
      expect(@agent.disabled?).to be_falsy
    end
  end

end