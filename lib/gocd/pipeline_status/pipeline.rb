module GOCD
  class Pipeline
    def initialize(pipeline)
      @pipeline = pipeline
    end

    def name
      @pipeline['name']
    end

    def last_build_status
      @pipeline['lastBuildStatus']
    end

    def status
      {pipeline: name, status: last_build_status}
    end

    def red?
      @pipeline['lastBuildStatus'] == 'Failure'
    end

    def green?
      @pipeline['lastBuildStatus'] == 'Success'
    end
  end
end