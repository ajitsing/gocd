require_relative './stage'

module GOCD
  module PIPELINE_CONFIG
    class Pipeline
      include GOCD::PIPELINE_CONFIG
      attr_reader :name, :stages

      def initialize(data)
        @name = data['name']
        @stages = to_stages(data['stage']) || []
      end

      private
      def to_stages(data)
        to_array(data).map { |stage| GOCD::PIPELINE_CONFIG::Stage.new(name, stage) } unless data.nil?
      end
    end
  end
end