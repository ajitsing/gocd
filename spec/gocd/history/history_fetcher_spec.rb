require_relative '../../../lib/gocd/history/history_fetcher'
require_relative '../../../lib/gocd/config/credentials'
require_relative '../../../lib/gocd/config/server'
require_relative '../../../lib/gocd/pipeline_config/job'
require 'rest-client'
require 'ostruct'

def setup_credential_and_server
  GOCD.credentials = GOCD::Credentials.new 'admin', 'password'
  GOCD.server = GOCD::Server.new 'http://gocd.com'
end

RSpec.describe GOCD::HistoryFetcher, 'history' do

  response = "cruise_agent,cruise_job_duration,cruise_job_id,cruise_job_result,cruise_pipeline_counter,cruise_pipeline_label,cruise_stage_counter,cruise_timestamp_01_scheduled,cruise_timestamp_02_assigned,cruise_timestamp_03_preparing,cruise_timestamp_04_building,cruise_timestamp_05_completing,cruise_timestamp_06_completed,tests_failed_count,tests_ignored_count,tests_total_count,tests_total_duration\nAgent1,320,826882,Passed,10314,pipe-10314-job-5621,1,2017-02-23T14:49:17Z,2017-02-23T14:49:22Z,2017-02-23T14:49:33Z,2017-02-23T14:49:41Z,2017-02-23T14:54:39Z,2017-02-23T14:55:02Z,0,0,4218,84.882\n"
  job = GOCD::PIPELINE_CONFIG::Job.new('Pipeline', 'stage', {'name' => 'job'})

  before(:each) do
    setup_credential_and_server
    params = "pipelineName=#{job.pipeline}&stageName=#{job.stage}&jobName=#{job.name}&limitPipeline=latest&limitCount=#{1}"
    request = {
        method: :get,
        url: "http://gocd.com/go/properties/search?#{params}",
        user: 'admin',
        password: 'password',
    }
    expect(RestClient::Request).to receive(:execute).with(request).and_return(OpenStruct.new({body: response}))
  end

  it 'should fetch history of a job' do
    histories = GOCD::HistoryFetcher.fetch_job_history(job, 1)

    expect(histories.size).to eq 1
    history = histories.first
    expect(history['cruise_agent']).to eq 'Agent1'
    expect(history['cruise_job_duration']).to eq '320'
    expect(history['cruise_job_id']).to eq '826882'
    expect(history['cruise_job_result']).to eq 'Passed'
    expect(history['cruise_pipeline_counter']).to eq '10314'
    expect(history['cruise_pipeline_label']).to eq 'pipe-10314-job-5621'
    expect(history['cruise_stage_counter']).to eq '1'
    expect(history['cruise_timestamp_01_scheduled']).to eq '2017-02-23T14:49:17Z'
    expect(history['cruise_timestamp_02_assigned']).to eq '2017-02-23T14:49:22Z'
    expect(history['cruise_timestamp_04_building']).to eq '2017-02-23T14:49:41Z'
    expect(history['cruise_timestamp_05_completing']).to eq '2017-02-23T14:54:39Z'
    expect(history['cruise_timestamp_06_completed']).to eq '2017-02-23T14:55:02Z'
  end

  it 'should fetch raw history of a job' do
    histories = GOCD::HistoryFetcher.fetch_raw_job_history(job, 1)

    expect(histories).to eq response
  end
end