require './lib/gocd/pipeline/pipeline'

RSpec.describe GOCD::Pipeline, 'pipeline' do

  context 'when last build status is success' do
    before(:each) do
      @raw_pipeline = { 'name' => 'pipeline 1', 'activity' => 'sleeping', 'lastBuildStatus' => 'Success' }
    end

    it '#name should return name' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.name).to eq 'pipeline 1'
    end

    it '#last_build_status should return last build status' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.last_build_status).to eq 'Success'
    end

    it '#green? should return true' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.green?).to be_truthy
    end

    it '#red? should return false' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.red?).to be_falsey
    end
  end

  context 'when last build status is failure' do
    before(:each) do
      @raw_pipeline = { 'name' => 'pipeline 1', 'activity' => 'sleeping', 'lastBuildStatus' => 'Failure' }
    end

    it '#green? should return false' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.green?).to be_falsey
    end

    it '#red? should return true' do
      @pipeline = GOCD::Pipeline.new @raw_pipeline
      expect(@pipeline.red?).to be_truthy
    end
  end

end