require_relative './environment'
require_relative './pipeline_group'
require_relative './pipeline'
require_relative './repository/pipeline_config_repository'

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
      merge_pipelines_with_templates pipelines
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

    def merge_pipelines_with_templates(pipelines)
      pipelines_with_template = pipelines.select { |p| p.has_template? }
      pipelines_with_template.map! do |p|
        template = template_for_pipeline(p)
        next if template.nil?
        template.name = p.name
        template.stages.each { |s| s.pipeline = p.name }
        template
      end.compact!

      pipelines_without_template = pipelines.select { |p| !p.has_template? }
      [pipelines_with_template + pipelines_without_template].flatten.compact
    end

    def template_for_pipeline(pipeline)
      template = templates.select { |t| t.name == pipeline.template }.first
      p "Could not find any template for #{pipeline.name}:#{pipeline.template}" if template.nil?
      template
    end
  end
end