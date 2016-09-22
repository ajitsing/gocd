module GOCD
  class Agent
    def initialize(response)
      @response = response
    end

    def name
      @response['hostname']
    end

    def uuid
      @response['uuid']
    end

    def ip_address
      @response['ip_address']
    end

    def os
      @response['operating_system']
    end

    def free_space
      @response['free_space']
    end

    def state
      @response['agent_state']
    end

    def disabled?
      @response['agent_config_state'] == 'Disabled'
    end

    def idle?
      @response['agent_state'] == 'Idle'
    end

    def building?
      @response['agent_state'] == 'Building'
    end

    def missing?
      @response['agent_state'] == 'Missing'
    end

    def resources
      @response['resources']
    end

    def has_resource(resource)
      resources.include? resource
    end

    def environments
      @responsep['environments']
    end

    def has_environment(env)
      environments.include? env
    end

    def location
      @response['sandbox']
    end
  end
end