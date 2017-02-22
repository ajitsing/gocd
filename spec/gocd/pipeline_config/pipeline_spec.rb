require './lib/gocd/pipeline_config/pipeline_group'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Pipeline, 'Pipeline' do
  xml_response = <<-PipelineGroup
    <pipeline name="MyAwesomePipeline" isLocked="false">
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
        <stage name="spec">
            <jobs>
                <job name="flavor1_spec" timeout="60">
                    <resources>
                        <resource>mac</resource>
                        <resource>spec</resource>
                    </resources>
                </job>
                <job name="flavor2_spec" timeout="60">
                    <resources>
                        <resource>mac</resource>
                        <resource>spec</resource>
                    </resources>
                </job>
            </jobs>
        </stage>
    </pipeline>
  PipelineGroup

  it 'should parse pipeline' do
    response = Hash.from_xml(xml_response)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new response['pipeline']

    expect(pipeline.name).to eq 'MyAwesomePipeline'
    expect(pipeline.stages.size).to eq 2
  end
end
