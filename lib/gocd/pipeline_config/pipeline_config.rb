require './lib/gocd/pipeline_config/environment'
require './lib/gocd/pipeline_config/pipeline_group'
require './lib/gocd/pipeline_config/pipeline'
require './lib/gocd/pipeline_config/repository/pipeline_config_repository'

module GOCD
  module PIPELINE_CONFIG
    @config_response = nil

    def environments
      raw_environments = pipeline_config_response["cruise"]["environments"]["environment"]
      environments = raw_environments.map do |environment|
        GOCD::PIPELINE_CONFIG::Environment.new(environment)
      end

      add_pipelines_to_environments environments, pipelines
      environments
    end

    def pipelines
      groups.map { |group| group.pipelines }.flatten
    end

    def groups
      raw_groups = pipeline_config_response['cruise']['pipelines']
      raw_groups.map do |group|
        GOCD::PIPELINE_CONFIG::PipelineGroup.new(group)
      end
    end

    def pipeline_config_response
      @config_response ||= PipelineConfigRepository.fetch_config
    end

    def to_array(data)
      [data].compact.flatten
    end

    private
    def add_pipelines_to_environments(environments, pipelines)
      environments.each do |environment|
        pipelines_for_env = []
        environment.pipeline_names.each do |pipeline|
          pipelines_for_env << pipelines.select { |p| p.name == pipeline }
        end
        environment.enrich_with_pipelines pipelines_for_env.flatten.compact
      end
    end
  end
end