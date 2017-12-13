module GOCD
  class AllPipelines
    class << self
      def information_available?
        !pipelines.nil?
      end

      def red_pipelines
        pipelines.select { |pipeline| pipeline.red? }
      end

      def green_pipelines
        pipelines.select { |pipeline| pipeline.green? }
      end

      def status
        pipelines.map { |pipeline| pipeline.status }
      end

      def any_red?
        !red_pipelines.empty?
      end

      def pipelines
        GOCD::PipelineRepository.pipelines
      end
    end
  end

  class PipelineGroup
    def initialize(pipelines)
      @pipelines = pipelines
    end

    def information_available?
      !pipelines.nil?
    end

    def red_pipelines
      pipelines.select { |pipeline| pipeline.red? }
    end

    def green_pipelines
      pipelines.select { |pipeline| pipeline.green? }
    end

    def status
      pipelines.map { |pipeline| pipeline.status }
    end

    def any_red?
      !red_pipelines.empty?
    end

    def pipelines
      all_pipelines = GOCD::PipelineRepository.pipelines
      missing_pipelines = []
      @pipelines.select do |pipeline|
        if all_pipelines.find { |p| p.name == pipeline }.nil?
          missing_pipelines << pipeline
        end
      end

      unless missing_pipelines.empty?
        exception = PipelinesNotFoundException.new(missing_pipelines)
        raise exception, exception.message
      end

      @pipelines.map do |pipeline|
        all_pipelines.find { |p| p.name == pipeline }
      end
    end
  end
end
