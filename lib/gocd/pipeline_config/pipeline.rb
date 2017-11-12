require_relative './stage'

module GOCD
  module PIPELINE_CONFIG
    class Pipeline
      include GOCD::PIPELINE_CONFIG
      attr_reader :name, :stages, :template, :environment, :params

      def initialize(data)
        @template = data['@template']
        @name = data['@name']
        @stages = to_stages(data['stage']) || []
        @params = parse_params(data)
      end

      def has_template?
        !template.nil?
      end

      def name=(new_name)
        @name = new_name
        @stages.each { |stage| stage.pipeline = new_name }
      end

      def environment=(env)
        @environment = env
        @stages.each { |stage| stage.environment = env }
      end

      private
      def to_stages(data)
        to_array(data).map { |stage| GOCD::PIPELINE_CONFIG::Stage.new(name, stage) } unless data.nil?
      end

      def parse_params(data)
        params = {}
        return params if (data['params'].nil? || data['params']['param'].nil?)

        params_response = data['params']['param']
        if params_response.is_a?(Hash)
          params[params_response['@name']] = params_response['$']
        elsif params_response.is_a?(Array)
          params_response.each { |p| params[p['@name']] = p['$'] }
        end

        params
      end
    end
  end
end