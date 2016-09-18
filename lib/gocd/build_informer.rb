require 'active_support/core_ext/hash/conversions'

module GOCD
  module PipelineStatus
    class BuildInformer
      def initialize
        @pipeline_statuses ||= Hash.from_xml(`curl -s -k -u #{GOCD.credentials.curl_credentials} #{GOCD.server.url}/go/cctray.xml`)
      end

      def information_available?
        !@pipeline_statuses.nil?
      end

      def red_pipelines
        pipelines.select { |stage| stage['lastBuildStatus'] == 'Failure' }
      end

      def status
        pipelines
      end

      def pipelines
        @pipeline_statuses['Projects']['Project']
      end
    end
  end
end
