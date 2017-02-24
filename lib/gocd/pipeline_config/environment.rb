require_relative './pipeline_config'

module GOCD
  module PIPELINE_CONFIG
    class Environment
      include GOCD::PIPELINE_CONFIG
      attr_reader :name, :pipelines, :pipeline_names

      def initialize(environment)
        @name = environment['name']
        @pipeline_names = to_pipelines(environment["pipelines"] || {})
      end

      def has_pipeline?(pipeline)
        pipelines.include? pipeline
      end

      def enrich_with_pipelines(pipelines)
        pipelines.each { |pipeline| pipeline.environment = name }
        @pipelines = pipelines
      end

      private
      def to_pipelines(pipelines)
        pipes = pipelines["pipeline"] || []
        to_array(pipes).map { |p| p['name'] } unless pipes.nil?
      end
    end
  end
end
