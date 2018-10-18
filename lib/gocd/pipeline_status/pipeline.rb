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
      {pipeline: name, status: current_status}
    end

    def red?
      @pipeline['lastBuildStatus'] == 'Failure'
    end

    def green?
      @pipeline['lastBuildStatus'] == 'Success'
    end

    def web_url
      @pipeline['webUrl']
    end

    def last_build_time
      @pipeline['lastBuildTime']
    end

    def last_build_label
      @pipeline['lastBuildLabel']
    end

    def to_hash
      @pipeline
    end

    def current_status
      (@pipeline['activity'] && @pipeline['activity'].downcase == 'sleeping') ? last_build_status : @pipeline['activity']
    end
  end
end
