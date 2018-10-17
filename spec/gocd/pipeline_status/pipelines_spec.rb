require './lib/gocd/pipeline_status/pipelines'
require_relative '../../../lib/gocd/pipeline_status/pipeline_repository'
require_relative '../../../lib/gocd/exception/pipelines_not_found_exception'

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

    context 'cache' do
      it 'should not fetch latest pipelines when cache is enabled' do
        mock_pipeline_repository

        GOCD::AllPipelines.pipelines(cache: false)
        GOCD::AllPipelines.any_red?(cache: true)
        GOCD::AllPipelines.red_pipelines(cache: true)
        GOCD::AllPipelines.green_pipelines(cache: true)
        GOCD::AllPipelines.status(cache: true)
      end
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

    it '#red_pipelines? should throw PipelinesNotFoundException when any of the pipeline is not present in the go response' do
      mock_pipeline_repository_with_green_pipelines
      pipeline_group = GOCD::PipelineGroup.new %w(pipeline1 pipeline3)
      expect{pipeline_group.any_red?}.to raise_error(PipelinesNotFoundException).with_message("Could not find [\"pipeline3\"]")
    end

    context 'cache' do
      it 'should not fetch latest pipelines when cache is enabled' do
        pipeline = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline1')
        expect(GOCD::PipelineRepository).to receive(:pipelines).once.and_return([pipeline])

        pipeline_group = GOCD::PipelineGroup.new %w(pipeline1)

        pipeline_group.pipelines(cache: true)
        pipeline_group.any_red?(cache: true)
        pipeline_group.red_pipelines(cache: true)
        pipeline_group.green_pipelines(cache: true)
        pipeline_group.status(cache: true)
      end

      it 'should not fetch latest pipelines when cache is enabled during initialization' do
        pipeline = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline1')
        expect(GOCD::PipelineRepository).to receive(:pipelines).once.and_return([pipeline])

        pipeline_group = GOCD::PipelineGroup.new %w(pipeline1), cache: true

        pipeline_group.pipelines
        pipeline_group.any_red?
        pipeline_group.red_pipelines
        pipeline_group.green_pipelines
        pipeline_group.status
      end

      it 'should fetch latest pipelines when cache is disabled during api call' do
        pipeline = instance_double("Pipeline", :red? => false, :green? => true, :status => 'passing', :name => 'pipeline1')
        expect(GOCD::PipelineRepository).to receive(:pipelines).twice.and_return([pipeline])

        pipeline_group = GOCD::PipelineGroup.new %w(pipeline1), cache: true

        pipeline_group.pipelines
        pipeline_group.any_red?(cache: false)
      end
    end
  end
end