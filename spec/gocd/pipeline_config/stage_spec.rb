require './lib/gocd/pipeline_config/pipeline_group'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Stage, 'Stage' do
  xml_response = <<-PipelineGroup
    <stage name="build">
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
    </stage>
  PipelineGroup

  it 'should parse stage' do
    response = Hash.from_xml(xml_response)
    stage = GOCD::PIPELINE_CONFIG::Stage.new 'MyAwesomePipeline', response['stage']

    expect(stage.name).to eq 'build'
    expect(stage.pipeline).to eq 'MyAwesomePipeline'
    expect(stage.jobs.size).to eq 2
  end
end
