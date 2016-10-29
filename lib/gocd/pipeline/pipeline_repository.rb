require 'active_support/core_ext/hash/conversions'

module GOCD
  class PipelineRepository
    def self.pipelines
      @pipelines = fetch_data
    end

    private
    def self.fetch_data
      raw_pipelines = Hash.from_xml(`curl -s -k -u #{GOCD.credentials.curl_credentials} #{GOCD.server.url}/go/cctray.xml`)
      to_pipelines raw_pipelines
    end

    def self.to_pipelines(raw_pipelines)
      raise GOCDDataFetchException, 'Could not fetch data from server!!' if raw_pipelines.nil?
      raw_pipelines['Projects']['Project'].map { |raw_pipeline| GOCD::Pipeline.new raw_pipeline }
    end
  end
end