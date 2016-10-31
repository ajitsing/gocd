require_relative '../../../lib/gocd/agents/agents_repository'
require_relative '../../../lib/gocd/config/credentials'
require_relative '../../../lib/gocd/config/server'
require_relative '../../../lib/gocd/exception/data_fetch_exception'


def setup_credential_and_server
  GOCD.credentials = GOCD::Credentials.new 'admin', 'password'
  GOCD.server = GOCD::Server.new 'http://gocd.com'
end

RSpec.describe GOCD::AgentRepository, 'agent' do

  response_json = '{
  "_embedded": {
    "agents": [
      {
        "uuid": "1q2w3e4r",
        "hostname": "agent 1",
        "ip_address": "10.131.2.150",
        "sandbox": "/Applications/GoAgent.app",
        "operating_system": "Mac OS X",
        "free_space": 76202508288,
        "agent_config_state": "Enabled",
        "agent_state": "Idle",
        "build_state": "Idle",
        "resources": [
          "java",
          "automation"
        ],
        "environments": [
          "Automation",
          "iOS"
        ]
      },
      {
        "uuid": "0p9o8i7u",
        "hostname": "agent 2",
        "ip_address": "10.131.2.150",
        "sandbox": "/Applications/GoAgent.app.2",
        "operating_system": "Mac OS X",
        "free_space": 76202504192,
        "agent_config_state": "Enabled",
        "agent_state": "Idle",
        "build_state": "Idle",
        "resources": [
          "promotion"
        ],
        "environments": [
          "iOS"
        ]
      }
    ]
  }
}'

  it '#agents should return all agent' do
    setup_credential_and_server
    curl_command = "curl -s -k -u admin:password http://gocd.com/go/api/agents -H 'Accept: application/vnd.go.cd.v2+json'"
    expect(GOCD::AgentRepository).to receive(:`).with(curl_command).and_return(response_json)

    agents = GOCD::AgentRepository.agents
    expect(agents.size).to eq 2
    expect(agents[0].name).to eq 'agent 1'
    expect(agents[0].uuid).to eq '1q2w3e4r'
    expect(agents[1].name).to eq 'agent 2'
    expect(agents[1].uuid).to eq '0p9o8i7u'

  end

  it '#agents should raise GOCDDataFetchException exception' do
    GOCD::AgentRepository.instance_variable_set(:@agents, nil)
    setup_credential_and_server
    curl_command = "curl -s -k -u admin:password http://gocd.com/go/api/agents -H 'Accept: application/vnd.go.cd.v2+json'"
    expect(GOCD::AgentRepository).to receive(:`).with(curl_command).and_return(nil)

    expect{GOCD::AgentRepository.agents}.to raise_error(GOCDDataFetchException).with_message('Could not fetch data from server!!')
  end
end