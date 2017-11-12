require './lib/gocd/pipeline_config/pipeline_group'
require 'cobravsmongoose'

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

  template_pipline = <<-PipelineGroup
    <pipeline name="MyAwesomePipeline" isLocked="false" template="MyAwesomeTemplate">
    </pipeline>
  PipelineGroup

  it 'should parse pipeline' do
    response = CobraVsMongoose.xml_to_hash(xml_response)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new response['pipeline']

    expect(pipeline.name).to eq 'MyAwesomePipeline'
    expect(pipeline.stages.size).to eq 2
    expect(pipeline.params.keys.size).to eq 0
  end

  it 'should parse pipeline created from template' do
    response = CobraVsMongoose.xml_to_hash(template_pipline)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new response['pipeline']

    expect(pipeline.name).to eq 'MyAwesomePipeline'
    expect(pipeline.template).to eq 'MyAwesomeTemplate'
  end

  it 'should update environment in stages' do
    stage = instance_double('stage')
    expect(GOCD::PIPELINE_CONFIG::Stage).to receive(:new).and_return(stage)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new({'stage' => [stage]})

    expect(stage).to receive(:environment=).with('Env')

    pipeline.environment = 'Env'
  end

  it 'should parse pipeline params' do
    pipeline_with_params = <<-Pipeline
    <pipeline name="ChildPipeline" isLocked="false" template="pipeline_template">
      <params>
        <param name="MODULE_NAME">Module1</param>
        <param name="UPSTREAM_PIPELINE">ParentPipeline</param>
      </params>
    </pipeline>
    Pipeline

    response = CobraVsMongoose.xml_to_hash(pipeline_with_params)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new response['pipeline']

    expect(pipeline.params.keys.size).to eq 2
    expect(pipeline.params['MODULE_NAME']).to eq 'Module1'
    expect(pipeline.params['UPSTREAM_PIPELINE']).to eq 'ParentPipeline'
  end

  it 'should parse pipeline with one param' do
    pipeline_with_params = <<-Pipeline
    <pipeline name="ChildPipeline" isLocked="false" template="pipeline_template">
      <params>
        <param name="MODULE_NAME">Module1</param>
      </params>
    </pipeline>
    Pipeline

    response = CobraVsMongoose.xml_to_hash(pipeline_with_params)
    pipeline = GOCD::PIPELINE_CONFIG::Pipeline.new response['pipeline']

    expect(pipeline.params.keys.size).to eq 1
    expect(pipeline.params['MODULE_NAME']).to eq 'Module1'
  end
end
