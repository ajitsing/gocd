module GOCD
  class Agents
    class << self
      def idle
        agents.select { |agent| agent.idle? }
      end

      def missing
        agents.select { |agent| agent.missing? }
      end

      def building
        agents.select { |agent| agent.building? }
      end

      def disabled
        agents.select { |agent| agent.disabled? }
      end

      def agents
        GOCD::AgentRepository.agents
      end
    end
  end
end