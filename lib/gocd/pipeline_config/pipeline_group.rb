require_relative './pipeline'

module GOCD
  module PIPELINE_CONFIG
    class PipelineGroup
      include GOCD::PIPELINE_CONFIG
      attr_reader :name, :pipelines

      def initialize(group_data)
        @name = group_data['group']
        @pipelines = to_pipelines(group_data['pipeline']) || []
      end

      private
      def to_pipelines(pipelines_data)
        to_array(pipelines_data).map { |pipeline| GOCD::PIPELINE_CONFIG::Pipeline.new(pipeline) } unless pipelines_data.nil?
      end
    end
  end
end