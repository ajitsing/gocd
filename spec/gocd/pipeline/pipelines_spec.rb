require './lib/gocd/pipeline/pipelines'
require_relative '../../../lib/gocd/pipeline/pipeline_repository'

def mock_pipeline_repository
  pipeline1 = instance_double("Pipeline", :red? => true, :green? => false, :status => 'failing', :name => 'pipeline1')
  pipeline2 = instance_double("Pipeline", :red? => true, :green? => false, :status => 'failing', :name => 'pipeline2')
  pipeline3 = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline3')
  expect(GOCD::PipelineRepository).to receive(:pipelines).and_return([pipeline1, pipeline2, pipeline3])
end

def mock_pipeline_repository_with_green_pipelines
  pipeline1 = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline1')
  pipeline2 = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline2')
  expect(GOCD::PipelineRepository).to receive(:pipelines).and_return([pipeline1, pipeline2])
end

RSpec.describe GOCD::AllPipelines, 'pipelines' do

  context 'All Pipelines' do

    it '#red_pipelines should return red pipelines' do
      mock_pipeline_repository
      expect(GOCD::AllPipelines.red_pipelines.size).to eq 2
    end

    it '#green_pipelines should return green pipelines' do
      mock_pipeline_repository
      expect(GOCD::AllPipelines.green_pipelines.size).to eq 1
    end

    it '#status should return pipelines status' do
      mock_pipeline_repository
      expect(GOCD::AllPipelines.status).to eq %w(failing failing passing)
    end

    it '#any_red? should return true when red pipeline found' do
      mock_pipeline_repository
      expect(GOCD::AllPipelines.any_red?).to be_truthy
    end

    it '#any_red? should return false when no red pipeline found' do
      mock_pipeline_repository_with_green_pipelines
      expect(GOCD::AllPipelines.any_red?).to be_falsy
    end
  end


  context 'Group Pipelines' do

    it '#red_pipelines should return red pipelines' do
      mock_pipeline_repository
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline3)
      expect(pipeline_group.red_pipelines.size).to eq 1
    end

    it '#green_pipelines should return green pipelines' do
      mock_pipeline_repository
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline3)
      expect(pipeline_group.green_pipelines.size).to eq 1
    end

    it '#status should return pipelines status' do
      mock_pipeline_repository
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline3)
      expect(pipeline_group.status).to eq %w(failing passing)
    end

    it '#any_red? should return true when red pipeline found' do
      mock_pipeline_repository
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline3)
      expect(pipeline_group.any_red?).to be_truthy
    end

    it '#any_red? should return false when no red pipeline found' do
      mock_pipeline_repository_with_green_pipelines
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline2)
      expect(pipeline_group.any_red?).to be_falsy
    end
  end
end