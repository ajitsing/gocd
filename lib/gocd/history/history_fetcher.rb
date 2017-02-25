require 'active_support/core_ext/hash/conversions'
require 'csv'
require 'rest-client'

module GOCD
  class HistoryFetcher
    def self.fetch_job_history(job, runs=100)
      response = fetch_raw_job_history(job, runs)
      CSV.parse(response, headers: true).map { |line| line.to_hash } unless response.nil?
    end

    def self.fetch_raw_job_history(job, runs=100)
      params = {pipelineName: job.pipeline, stageName: job.stage, jobName: job.name, limitPipeline: 'latest', limitCount: runs}
      params = URI.encode_www_form(params)
      request = {
          method: :get,
          url: "#{GOCD.server.url}/go/properties/search?#{params}",
          user: GOCD.credentials.username,
          password: GOCD.credentials.password,
      }

      begin
        res = RestClient::Request.execute(request)
        response = res.body unless res.nil?
      rescue => e
        error = <<-ERROR
          Could not fetch history for #{job.pipeline}::#{job.stage}::#{job.name}
          Response received from server: #{e.response}
        ERROR
        response = nil
        puts error
      end
      response
    end
  end
end