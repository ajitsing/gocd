require_relative './job'

module GOCD
  module PIPELINE_CONFIG
    class Stage
      include GOCD::PIPELINE_CONFIG
      attr_reader :pipeline, :name, :jobs

      def initialize(pipeline, data)
        @pipeline = pipeline
        @name = data['name']
        @jobs = to_jobs(data['jobs']['job'])
      end

      private
      def to_jobs(data)
        to_array(data).map { |job| GOCD::PIPELINE_CONFIG::Job.new(pipeline, name, job) }
      end
    end
  end
end