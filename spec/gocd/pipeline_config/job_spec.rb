require './lib/gocd/pipeline_config/pipeline_group'
require 'cobravsmongoose'

RSpec.describe GOCD::PIPELINE_CONFIG::Job, 'Job' do
  xml_response = <<-Job
    <job name="flavor1_spec" timeout="60">
        <resources>
            <resource>mac</resource>
            <resource>spec</resource>
        </resources>
    </job>
  Job

  it 'should parse job' do
    response = CobraVsMongoose.xml_to_hash(xml_response)
    job = GOCD::PIPELINE_CONFIG::Job.new 'MyAwesomePipeline', 'spec', response['job']

    expect(job.resources.size).to eq 2
    expect(job.resources.first).to eq 'mac'
    expect(job.pipeline).to eq 'MyAwesomePipeline'
    expect(job.stage).to eq 'spec'
  end

  it 'should parse job with resources as array' do
    xml_response = <<-Job
    <job name="flavor1_spec" timeout="60" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <resources>
            <resource>mac</resource>
            <resource>spec</resource>
        </resources>
    </job>
    Job

    response = CobraVsMongoose.xml_to_hash(xml_response)
    job = GOCD::PIPELINE_CONFIG::Job.new 'MyAwesomePipeline', 'spec', response['job']

    expect(job.resources.size).to eq 2
    expect(job.resources.first).to eq 'mac'
  end
end
