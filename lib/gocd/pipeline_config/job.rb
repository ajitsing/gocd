require_relative './pipeline_config'

module GOCD
  module PIPELINE_CONFIG
    class Job
      include GOCD::PIPELINE_CONFIG
      attr_reader :pipeline, :stage, :name, :resources, :environment

      def initialize(pipeline, stage, data)
        @pipeline = pipeline
        @stage = stage
        @name = data['@name']
        @resources = data['resources'].nil? ? [] : to_array(parse_resources(data))
      end

      def environment=(env)
        @environment = env
      end

      def pipeline=(new_name)
        @pipeline = new_name
      end

      private
      def parse_resources(data)
        res = data['resources']['resource']
        if res.is_a?(Array)
          res.map do |r|
            r.is_a?(Hash) ? filter_xml_specific_keys(r).values : r
          end
        elsif res.is_a?(Hash)
          filter_xml_specific_keys(res).values
        end
      end

      def filter_xml_specific_keys(res)
        res.delete('@xmlns')
        res
      end
    end
  end
end