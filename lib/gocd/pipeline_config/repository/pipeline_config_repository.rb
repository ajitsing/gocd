require 'cobravsmongoose'

module GOCD
  module PIPELINE_CONFIG
    class PipelineConfigRepository
      def self.fetch_config
        CobraVsMongoose.xml_to_hash(`curl -s -k -u #{GOCD.credentials.curl_credentials} #{GOCD.server.url}/go/api/admin/config/current.xml`)
      end
    end
  end
end
