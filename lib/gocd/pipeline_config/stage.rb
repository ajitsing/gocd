require_relative './job'

module GOCD
  module PIPELINE_CONFIG
    class Stage
      include GOCD::PIPELINE_CONFIG
      attr_reader :pipeline, :name, :jobs, :environment

      def initialize(pipeline, data)
        @pipeline = pipeline
        @name = data['name']
        @jobs = data['jobs'].nil? ? [] : to_jobs(data['jobs']['job'])
      end


      def environment=(env)
        @environment = env
        @jobs.each { |job| job.environment = env }
      end

      def pipeline=(new_name)
        @pipeline = new_name
        @jobs.each { |job| job.pipeline = new_name }
      end

      private
      def to_jobs(data)
        to_array(data).map { |job| GOCD::PIPELINE_CONFIG::Job.new(pipeline, name, job) }
      end
    end
  end
end