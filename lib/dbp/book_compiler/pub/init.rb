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
        COVER_IMAGE_TEMPLATE = TEMPLATES_DIR / 'cover.jpg'
        MINIMAL_TEMPLATE = 'minimal'

        SLUG = Pathname.pwd.basename
        DEFAULT_MSS_FILE = Pathname('mss') / SLUG.sub_ext('.scriv')

        PUBLICATION_DIR = Pathname('publication')
        PUBLICATION_YAML_FILE = PUBLICATION_DIR / 'publication.yaml'
        PUBLICATION_COVER_IMAGE_FILE = PUBLICATION_DIR / 'epub/publication/cover.jpg'

        def initialize(command = nil)
          super command, 'init'
          local_cover_image_path = Pathname("covers/#{SLUG}-cover-2400.jpg")
          @default_cover_image_file = local_cover_image_path if local_cover_image_path.file?
          @default_cover_image_file ||= COVER_IMAGE_TEMPLATE
        end

        def run
          parse_command_line
          create_publication_dir
          copy_publication_yaml_file
          copy_template if @template
          copy_cover_image_file if @cover
          translate_manuscript if @mss
        end

        def list_templates
          TEMPLATES_DIR.each_child.select(&:directory?).each { |e| puts "   #{e.basename}" }
        end

        def create_publication_dir
          return if PUBLICATION_DIR.directory?
          PUBLICATION_DIR.mkpath
          puts "Created #{PUBLICATION_DIR}"
        end

        def translate_manuscript
          sh 'scriv2tex', @mss_scrivener_file.to_s, PUBLICATION_DIR.to_s
          puts "Translated manuscript from: #{@mss_scrivener_file}"
        end

        def copy_publication_yaml_file
          return if PUBLICATION_YAML_FILE.file?
          FileUtils.cp PUBLICATION_YAML_TEMPLATE.to_s, PUBLICATION_DIR.to_s
          puts "Created #{PUBLICATION_YAML_FILE}"
        end

        def copy_cover_image_file
          PUBLICATION_COVER_IMAGE_FILE.dirname.mkpath
          FileUtils.cp @cover_image_file.to_s, PUBLICATION_COVER_IMAGE_FILE.to_s
          puts "Copied cover image file from: #{@cover_image_file}"
        end

        def copy_template
          [MINIMAL_TEMPLATE, template_name].uniq.each do |template_name|
            FileUtils.cp_r "#{TEMPLATES_DIR / template_name}/.", PUBLICATION_DIR.to_s
          end
          puts "Copied template #{template_name}"
        end

        def template_name
          @template_name ||= MINIMAL_TEMPLATE
        end

        def declare_options(parser)
          parser.on('--template [NAME]', 'copy files from a template') do |name|
            @template = true
            @template_name = name
          end

          parser.on('--cover [IMAGE_FILE]', Pathname, 'copy a cover image file') do |image_file|
            @cover = true
            @cover_image_file = image_file || @default_cover_image_file
          end

          parser.on('--mss [SCRIVENER_FILE]', Pathname, 'translate a Scrivener file as a manuscript') do |scrivener_file|
            @mss = true
            @mss_scrivener_file = scrivener_file || DEFAULT_MSS_FILE
          end

          parser.on('--force', 'write into existing publication directory') do |force|
            @force = force
          end

          parser.on('--list', 'list available templates and exit') do |_|
            list_templates
            exit
          end
        end

        def check_options(errors)
          check_publication_dir(errors)
          check_publication_yaml_file(errors)
          check_template(errors)
          check_cover_image_file(errors)
          check_mss_file(errors)
        end

        def check_mss_file(errors)
          return unless @mss
          return errors << "No such scrivener file: #{@mss_scrivener_file}" unless @mss_scrivener_file.exist?
          return errors << "Invalid scrivener file: #{@mss_scrivener_file}" unless @mss_scrivener_file.directory?
          scrivx = @mss_scrivener_file / @mss_scrivener_file.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{@mss_scrivener_file}" unless scrivx.file?
        end

        def check_publication_dir(errors)
          errors << "#{PUBLICATION_DIR} is a file" if PUBLICATION_DIR.file?
          return if @force
          errors << "Use --force to write into existing directory: #{PUBLICATION_DIR}" if PUBLICATION_DIR.directory?
        end

        def check_cover_image_file(errors)
          return unless @cover
          return errors << "No such cover image file: #{@cover_image_file}" unless @cover_image_file.exist?
          errors << "#{@cover_image_file} is a directory" if @cover_image_file.directory?
        end

        def check_publication_yaml_file(errors)
          errors << "#{PUBLICATION_YAML_FILE} is a directory" if PUBLICATION_YAML_FILE.directory?
        end

        def check_template(errors)
          return unless @template
          template_dir = TEMPLATES_DIR / template_name
          errors << "No such template: #{template_name}" unless template_dir.directory?
        end
      end
    end
  end
end
