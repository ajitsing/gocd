require './lib/gocd/pipeline_status/pipeline'

RSpec.describe GOCD::Pipeline, 'pipeline' do

  context 'when last build status is success' do
    before(:each) do
      @raw_pipeline = {'name' => 'pipeline 1', 'activity' => 'sleeping', 'lastBuildStatus' => 'Success'}
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
      @raw_pipeline = {'name' => 'pipeline 1', 'activity' => 'sleeping', 'lastBuildStatus' => 'Failure'}
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

  it 'should have other details' do
    @raw_pipeline = {
        'name' => 'pipeline 1', 'activity' => 'sleeping',
        'lastBuildStatus' => 'Success', 'webUrl' => 'http://someurl.com',
        'lastBuildLabel' => 'lable', 'lastBuildTime' => '2017-02-28'
    }

    pipeline = GOCD::Pipeline.new @raw_pipeline
    expect(pipeline.web_url).to eq('http://someurl.com')
    expect(pipeline.last_build_time).to eq('2017-02-28')
    expect(pipeline.last_build_label).to eq('lable')
    expect(pipeline.to_hash).to eq(@raw_pipeline)
  end
end