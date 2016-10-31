require_relative '../../../lib/gocd/pipeline/pipeline_repository'
require_relative '../../../lib/gocd/config/credentials'
require_relative '../../../lib/gocd/config/server'
require_relative '../../../lib/gocd/exception/data_fetch_exception'


def setup_credential_and_server
  GOCD.credentials = GOCD::Credentials.new 'admin', 'password'
  GOCD.server = GOCD::Server.new 'http://gocd.com'
end

RSpec.describe GOCD::PipelineRepository, 'pipelines' do

  response_xml = '<?xml version="1.0" encoding="utf-8"?>
  <Projects>
    <Project name="pipeline1" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="kernel-5044" lastBuildTime="2016-10-28T04:31:37" webUrl="http://go.lgnbrry.com/go/pipelines/Mobile_Web/5044/kernel/1" />
    <Project name="pipeline2" activity="Sleeping" lastBuildStatus="Success" lastBuildLabel="kernel-5044" lastBuildTime="2016-10-28T04:31:37" webUrl="http://go.lgnbrry.com/go/tab/build/detail/Mobile_Web/5044/kernel/1/spec" />
  </Projects>'

  it '#pipelines should return all pipelines' do
    setup_credential_and_server
    curl_command = 'curl -s -k -u admin:password http://gocd.com/go/cctray.xml'
    expect(GOCD::PipelineRepository).to receive(:`).with(curl_command).and_return(response_xml)

    pipelines = GOCD::PipelineRepository.pipelines
    expect(pipelines.size).to eq 2
    expect(pipelines[0].name).to eq 'pipeline1'
    expect(pipelines[0].last_build_status).to eq 'Success'
    expect(pipelines[1].name).to eq 'pipeline2'
    expect(pipelines[1].last_build_status).to eq 'Success'

  end

  it '#pipelines should raise GOCDDataFetchException exception' do
    GOCD::PipelineRepository.instance_variable_set(:@pipelines, nil)
    setup_credential_and_server
    curl_command = 'curl -s -k -u admin:password http://gocd.com/go/cctray.xml'
    empty_response = ''
    expect(GOCD::PipelineRepository).to receive(:`).with(curl_command).and_return(empty_response)

    expect{GOCD::PipelineRepository.pipelines}.to raise_error(GOCDDataFetchException).with_message('Could not fetch data from server!!')
  end
end