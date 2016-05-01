require 'pathname'
require 'rake'
require 'rake/file_utils'
require 'dbp'
require 'dbp/book_compiler/util/cli'

module DBP
  module BookCompiler
    module Pub
      class Init
        include BookCompiler::CLI
        include FileUtils

        TEMPLATES_DIR = DBP.templates_dir
        PUBLICATION_YAML_TEMPLATE = TEMPLATES_DIR / 'publication.yaml'
        MINIMAL_TEMPLATE = 'minimal'

        SLUG = Pathname.pwd.dirname.basename
        DEFAULT_MSS_FILE = Pathname('mss') / SLUG.sub_ext('.scriv')
        PUBLICATION_DIR = Pathname('publication')
        PUBLICATION_YAML_FILE = PUBLICATION_DIR / 'publication.yaml'

        def initialize(command = nil)
          super command, 'init'
        end

        def run
          parse_command_line
          create_publication_dir if @template || @yaml || @mss_file
          copy_template if @template
          copy_publication_yaml_file if @yaml
          translate_manuscript if @mss_file
        end

        def list_templates
          TEMPLATES_DIR.each_child.select(&:directory?).each { |e| puts "   #{e.basename}" }
        end

        def create_publication_dir
          PUBLICATION_DIR.mkpath
        end

        def translate_manuscript
          sh 'scriv2tex', @mss_file.to_s, PUBLICATION_DIR.to_s
        end

        def copy_publication_yaml_file
          FileUtils.cp PUBLICATION_YAML_TEMPLATE.to_s, PUBLICATION_DIR.to_s
        end

        def copy_template
          [MINIMAL_TEMPLATE, @template].uniq.each do |template|
            FileUtils.cp_r "#{TEMPLATES_DIR / template}/.", PUBLICATION_DIR.to_s
          end
        end

        def declare_options(parser)
          parser.on('--force', 'overwrite existing files') do |force|
            @force = force
          end

          parser.on('--list', 'list available templates') do |_|
            list_templates
          end

          parser.on('--mss [SCRIV]', Pathname, "create manuscript files by translating a Scrivener file  #{DEFAULT_MSS_FILE}") do |mss_file|
            @mss_file = mss_file || DEFAULT_MSS_FILE
          end

          parser.on('--template [TEMPLATE]', "copy files from a template (default: #{MINIMAL_TEMPLATE})") do |template|
            @template = template || MINIMAL_TEMPLATE
          end

          parser.on('--yaml', 'create a skeleton publication.yaml file ') do |yaml|
            @yaml = yaml
          end
        end

        def check_options(errors)
          check_publication_dir(errors)
          check_publication_yaml_file(errors)
          check_template(errors)
          check_mss_file(errors)
        end

        def check_mss_file(errors)
          return if @mss_file.nil?
          return errors << "No such scrivener file: #{@mss_file}" unless @mss_file.exist?
          return errors << "Invalid scrivener file: #{@mss_file}" unless @mss_file.directory?
          scrivx = @mss_file / @mss_file.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{@mss_file}" unless scrivx.file?
        end

        def check_publication_dir(errors)
          errors << "#{PUBLICATION_DIR} is a file" if PUBLICATION_DIR.file?
          return if @force
          errors << "Use --force to write into existing directory: #{PUBLICATION_DIR}" if PUBLICATION_DIR.directory?
        end

        def check_publication_yaml_file(errors)
          errors << "#{PUBLICATION_YAML_FILE} is a directory" if PUBLICATION_YAML_FILE.directory?
          return if @force
          errors << "Use --force to overwrite existing file: #{PUBLICATION_YAML_FILE}" if PUBLICATION_YAML_FILE.file?
        end

        def check_template(errors)
          return unless @template
          template_dir = TEMPLATES_DIR / @template
          errors << "No such template: #{@template}" unless template_dir.directory?
        end
      end
    end
  end
end