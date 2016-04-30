require 'dbp'
require 'dbp/book_compiler/util/cli'
require 'rake'
require 'rake/file_utils'

module DBP
  module BookCompiler
    module Pub
      class Init
        include BookCompiler::CLI
        include FileUtils

        TEMPLATES_DIR = DBP.templates_dir
        PUBLICATION_YAML_TEMPLATE = TEMPLATES_DIR / 'publication.yaml'
        MINIMAL_TEMPLATE = TEMPLATES_DIR / 'minimal'

        def initialize(command = nil)
          super command, 'init'
        end

        def run
          parse_command_line do |operands|
            @pub_dir = operands.shift&.instance_eval { |pub_dir| Pathname(pub_dir) }
          end

          @pub_dir&.mkpath
          init_template unless @template_name.nil?
          init_yaml if @pub_yaml
          init_manuscript if @scrivener_file&.directory?
        end

        def list_templates
          TEMPLATES_DIR.each_child.select(&:directory?).each { |e| puts "   #{e.basename}" }
        end

        def init_manuscript
          sh 'scriv2tex', @scrivener_file.to_s, @pub_dir.to_s
        end

        def init_yaml
          FileUtils.cp PUBLICATION_YAML_TEMPLATE, @pub_dir
        end

        def init_template
          @pub_dir.mkpath
          ['minimal', @template_name].each do |template_name|
            FileUtils.cp_r "#{TEMPLATES_DIR / template_name}/.", @pub_dir
          end
        end

        def declare_options(parser)
          parser.banner << ' [pub_dir]'

          parser.on('--force', 'overwrite existing files') do |force|
            @force = force
          end

          parser.on('--list', 'list available templates') do |list|
            list_templates
            @query_options_specified ||= list
          end

          parser.on('--scriv SCRIV', Pathname, 'create manuscript files from a Scrivener file') do |scrivener_file|
            @scrivener_file = scrivener_file
          end

          parser.on('--template TEMPLATE', 'create publication files from a template') do |template_name|
            @template_name = template_name
          end

          parser.on('--yaml', 'create a skeleton publication.yaml file ') do |pub_yaml|
            @pub_yaml = pub_yaml
          end
        end

        def check_options(errors)
          check_template(errors)
          check_pub_dir(errors)
          check_pub_yaml(errors)
          check_scrivener_file(errors)
        end

        def check_scrivener_file(errors)
          return if @scrivener_file.nil?
          errors << "No such scrivener file: #{@scrivener_file}" unless @scrivener_file.directory?
          scrivx = @scrivener_file / @scrivener_file.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{@scrivener_file}" unless scrivx.file?
        end

        def check_pub_dir(errors)
          errors << 'no pub_dir specified' unless @pub_dir || @query_options_specified
          return if @pub_dir.nil?
          errors << "pub_dir '#{@pub_dir}' already exists and is a file" if @pub_dir&.file?
          return if @force
          errors << "pub_dir '#{@pub_dir}' directory already exists (use --force to override)" if @pub_dir&.directory?
        end

        def check_pub_yaml(errors)
          return if @pub_dir.nil?
          publication_yaml_file = @pub_dir / PUBLICATION_YAML_TEMPLATE.basename
          errors << "'#{publication_yaml_file}' is a directory" if publication_yaml_file&.directory?
          return if @force
          errors << "'#{publication_yaml_file}' file already exists (use --force to override)" if publication_yaml_file.file?
        end

        def check_template(errors)
          return unless @template_name
          template_dir = TEMPLATES_DIR / @template_name
          errors << "No such template: #{@template_name}" unless template_dir.directory?
        end
      end
    end
  end
end