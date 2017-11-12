require './lib/gocd/pipeline_config/pipeline_group'
require 'cobravsmongoose'

RSpec.describe GOCD::PIPELINE_CONFIG::PipelineGroup, 'PipelineGroup' do
  pipeline_group_xml = <<-PipelineGroup
    <pipelines group="MyPipelineGroup">
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
    </pipelines>
  PipelineGroup

  it 'should parse pipeline group' do
    response = CobraVsMongoose.xml_to_hash(pipeline_group_xml)
    pipeline_group = GOCD::PIPELINE_CONFIG::PipelineGroup.new response['pipelines']

    expect(pipeline_group.name).to eq 'MyPipelineGroup'
  end
end
