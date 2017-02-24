require './lib/gocd/pipeline_config/pipeline_group'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Environment, 'Environment' do
  xml_response = <<-PipelineGroup
    <environment name="Env">
      <agents>
        <physical uuid="276cc6fa-e97f-914f9a1acaa4-45f6-b78d" />
        <physical uuid="2828cc5c-7bad-2c99c81638b3-49b8-a83b" />
      </agents>
      <pipelines>
        <pipeline name="Pipeline1" />
        <pipeline name="Pipeline2" />
      </pipelines>
    </environment>
  PipelineGroup

  it 'should parse environment' do
    response = Hash.from_xml(xml_response)
    environment = GOCD::PIPELINE_CONFIG::Environment.new response['environment']

    expect(environment.name).to eq 'Env'
    expect(environment.pipeline_names.size).to eq 2
    expect(environment.pipeline_names.first).to eq 'Pipeline1'
    expect(environment.pipeline_names.last).to eq 'Pipeline2'
  end

  it 'should update environment in pipeline' do
    response = Hash.from_xml(xml_response)
    environment = GOCD::PIPELINE_CONFIG::Environment.new response['environment']

    pipeline = instance_double('pipeline')
    expect(pipeline).to receive(:environment=).with('Env')

    environment.enrich_with_pipelines([pipeline])
  end
end
