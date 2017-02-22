require_relative './pipeline_config'

module GOCD
  module PIPELINE_CONFIG
    class Job
      include GOCD::PIPELINE_CONFIG
      attr_reader :pipeline, :stage, :name, :resources

      def initialize(pipeline, stage, data)
        @pipeline = pipeline
        @stage = stage
        @name = data['name']
        @resources = data['resources'].nil? ? [] : data['resources']['resource']
      end

      def pipeline=(new_name)
        @pipeline = new_name
      end
    end
  end
end