require 'json'

module GOCD
  class AgentRepository
    def self.agents
      @agents ||= fetch
    end

    private
    def self.fetch
      raw_agents = `curl -s -k -u #{GOCD.credentials.curl_credentials} #{GOCD.server.url}/go/api/agents -H 'Accept: application/vnd.go.cd.v2+json'`
      to_agents raw_agents
    end

    def self.to_agents(raw_agents)
      raise GOCDDataFetchException, 'Could not fetch data from server!!' if raw_agents.nil?
      agents_hash = JSON.parse(raw_agents)
      agents_hash['_embedded']['agents'].map { |agent_response| GOCD::Agent.new agent_response }
    end
  end
end