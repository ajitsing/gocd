class PipelinesNotFoundException < Exception
  attr_reader :missing_pipelines

  def initialize(missing_pipelines)
    @missing_pipelines = missing_pipelines
  end

  def message
    "Could not find #{@missing_pipelines}"
  end
end