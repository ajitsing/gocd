require_relative './pipeline_config'

module GOCD
  module PIPELINE_CONFIG
    class Job
      include GOCD::PIPELINE_CONFIG
      attr_reader :pipeline, :stage, :name, :resources, :environment

      def initialize(pipeline, stage, data)
        @pipeline = pipeline
        @stage = stage
        @name = data['name']
        @resources = data['resources'].nil? ? [] : to_array(data['resources']['resource'])
      end

      def environment=(env)
        @environment = env
      end

      def pipeline=(new_name)
        @pipeline = new_name
      end
    end
  end
end