module GOCD
  class AllPipelines
    class << self
      DEFAULT_OPTS = {cache: false}

      def information_available?
        !pipelines.nil?
      end

      def red_pipelines(opts = {})
        pipelines(opts).select { |pipeline| pipeline.red? }
      end

      def green_pipelines(opts = {})
        pipelines(opts).select { |pipeline| pipeline.green? }
      end

      def status(opts = {})
        pipelines(opts).map { |pipeline| pipeline.status }
      end

      def any_red?(opts = {})
        !red_pipelines(opts).empty?
      end

      def pipelines(opts = {})
        merged_opts = DEFAULT_OPTS.merge(opts)
        if merged_opts[:cache]
          @pipelines ||= GOCD::PipelineRepository.pipelines
        else
          @pipelines = GOCD::PipelineRepository.pipelines
        end
      end
    end
  end

  class PipelineGroup
    def initialize(pipelines, opts = {})
      @pipelines = pipelines
      @default_opts = {cache: false}.merge(opts)
    end

    def information_available?
      !pipelines.nil?
    end

    def red_pipelines(opts = {})
      pipelines(opts).select { |pipeline| pipeline.red? }
    end

    def green_pipelines(opts = {})
      pipelines(opts).select { |pipeline| pipeline.green? }
    end

    def status(opts = {})
      pipelines(opts).map { |pipeline| pipeline.status }
    end

    def any_red?(opts = {})
      !red_pipelines(opts).empty?
    end

    def pipelines(opts = {})
      merged_opts = @default_opts.merge(opts)
      if merged_opts[:cache]
        @all_pipelines ||= GOCD::PipelineRepository.pipelines
      else
        @all_pipelines = GOCD::PipelineRepository.pipelines
      end

      missing_pipelines = []
      @pipelines.select do |pipeline|
        if @all_pipelines.find { |p| p.name == pipeline }.nil?
          missing_pipelines << pipeline
        end
      end

      unless missing_pipelines.empty?
        exception = PipelinesNotFoundException.new(missing_pipelines)
        raise exception, exception.message
      end

      @pipelines.map do |pipeline|
        @all_pipelines.find { |p| p.name == pipeline }
      end
    end
  end
end
