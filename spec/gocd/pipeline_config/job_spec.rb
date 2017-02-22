require './lib/gocd/pipeline_config/pipeline_group'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Job, 'Job' do
  xml_response = <<-PipelineGroup
    <job name="flavor1_spec" timeout="60">
        <resources>
            <resource>mac</resource>
            <resource>spec</resource>
        </resources>
    </job>
  PipelineGroup

  it 'should parse job' do
    response = Hash.from_xml(xml_response)
    job = GOCD::PIPELINE_CONFIG::Job.new 'MyAwesomePipeline', 'spec', response['job']

    expect(job.resources.size).to eq 2
    expect(job.resources.first).to eq 'mac'
    expect(job.pipeline).to eq 'MyAwesomePipeline'
    expect(job.stage).to eq 'spec'
  end
end
