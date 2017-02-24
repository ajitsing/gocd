require './lib/gocd/pipeline_config/pipeline_group'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Stage, 'Stage' do
  xml_response = <<-PipelineGroup
    <job name="build">
        <jobs>
            <job name="flavor1_build">
                <resources>
                    <resource>mac</resource>
                    <resource>build</resource>
                </resources>
            </job>
            <job name="flavor2_build">
                <resources>
                    <resource>mac</resource>
                    <resource>build</resource>
                </resources>
            </job>
        </jobs>
    </job>
  PipelineGroup

  it 'should parse job' do
    response = Hash.from_xml(xml_response)
    stage = GOCD::PIPELINE_CONFIG::Stage.new 'MyAwesomePipeline', response['job']

    expect(stage.name).to eq 'build'
    expect(stage.pipeline).to eq 'MyAwesomePipeline'
    expect(stage.jobs.size).to eq 2
  end

  it 'should update environment in jobs' do
    job = instance_double('job')
    expect(GOCD::PIPELINE_CONFIG::Job).to receive(:new).and_return(job)
    stage = GOCD::PIPELINE_CONFIG::Stage.new('pipeline', {'jobs' => {'job' => job}})

    expect(job).to receive(:environment=).with('Env')

    stage.environment = 'Env'
  end
end
