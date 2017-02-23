require 'active_support/core_ext/hash/conversions'
require 'csv'

module GOCD
  class HistoryFetcher
    def self.fetch_job_history(job, runs=100)
      response = fetch_raw_job_history(job, runs)
      CSV.parse(response, headers: true).map { |line| line.to_hash } unless response.nil?
    end

    def self.fetch_raw_job_history(job, runs=100)
      params = "pipelineName=#{job.pipeline}&stageName=#{job.stage}&jobName=#{job.name}&limitPipeline=latest&limitCount=#{runs}"
      `curl -s -k -u #{GOCD.credentials.curl_credentials} "#{GOCD.server.url}/go/properties/search?#{params}"`
    end
  end
end