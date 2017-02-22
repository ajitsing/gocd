require './lib/gocd/pipeline_config/environment'
require './lib/gocd/pipeline_config/pipeline_group'
require './lib/gocd/pipeline_config/pipeline'
require './lib/gocd/pipeline_config/repository/pipeline_config_repository'

module GOCD
  module PIPELINE_CONFIG
    @config_response = nil

    def environments
      raw_environments = to_array(pipeline_config_response["cruise"]["environments"]["environment"])
      environments = raw_environments.map do |environment|
        GOCD::PIPELINE_CONFIG::Environment.new(environment)
      end

      add_pipelines_to_environments environments, pipelines
      environments
    end

    def pipelines
      pipelines = groups.map { |group| group.pipelines }.flatten
      merge_pipelines_with_templates pipelines, templates
    end

    def templates
      raw_templates = to_array(pipeline_config_response["cruise"]["templates"]["pipeline"])
      raw_templates.map { |template| GOCD::PIPELINE_CONFIG::Template.new(template) }
    end

    def groups
      raw_groups = to_array(pipeline_config_response['cruise']['pipelines'])
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

    def merge_pipelines_with_templates(pipelines, templates)
      pipeline_with_templates = pipelines.select { |p| p.has_template? }
      standalone_pipelines = pipelines - pipeline_with_templates

      pipelines_merged_with_templates = pipeline_with_templates.map do |pwt|
        matched_template = templates.select { |t| t.name.upcase == pwt.template.upcase }
        if matched_template.size > 0
          matched_template.first.name = pwt.name
          matched_template
        else
          pwt
        end
      end
      [standalone_pipelines + pipelines_merged_with_templates].flatten.compact
    end
  end
end