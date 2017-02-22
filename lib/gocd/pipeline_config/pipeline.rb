require_relative './stage'

module GOCD
  module PIPELINE_CONFIG
    class Pipeline
      include GOCD::PIPELINE_CONFIG
      attr_reader :name, :stages, :template

      def initialize(data)
        @template = data['template']
        @name = data['name']
        @stages = to_stages(data['stage']) || []
      end

      def has_template?
        !template.nil?
      end

      def name=(new_name)
        @name = new_name
        @stages.each { |stage| stage.pipeline = new_name }
      end

      private
      def to_stages(data)
        to_array(data).map { |stage| GOCD::PIPELINE_CONFIG::Stage.new(name, stage) } unless data.nil?
      end
    end
  end
end