require './lib/gocd/pipeline_config/template'
require 'active_support/core_ext/hash/conversions'

RSpec.describe GOCD::PIPELINE_CONFIG::Template, 'Template' do
  xml_response = <<-Template
    <templates>
    <pipeline name="MyPipeline">
      <stage name="prepare">
        <jobs>
          <job name="job1">
            <resources>
              <resource>promotion</resource>
              <resource>mac</resource>
            </resources>
          </job>
        </jobs>
      </stage>
    </pipeline>
  </templates>
  Template

  it 'should parse template' do
    response = Hash.from_xml(xml_response)
    pipeline = GOCD::PIPELINE_CONFIG::Template.new response['templates']['pipeline']

    expect(pipeline.name).to eq 'MyPipeline'
    expect(pipeline.template.nil?).to be_truthy
    expect(pipeline.stages.size).to eq 1
    expect(pipeline.stages.first.jobs.size).to eq 1
    expect(pipeline.stages.first.jobs.first.resources.size).to eq 2
  end
end
