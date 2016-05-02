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
        COVER_DEFAULT_SOURCE = TEMPLATES_DIR / 'cover.jpg'
        YAML_SOURCE = TEMPLATES_DIR / 'publication.yaml'
        MINIMAL_TEMPLATE = 'minimal'

        PUBLICATION_DIR = Pathname('publication')

        def initialize(command = nil)
          super command, 'init'
        end

        def run
          parse_command_line
          init_pub_dir
          init_yaml
          init_template if @template
          init_cover if @cover
          init_mss if @mss
        end

        def init_pub_dir
          return if PUBLICATION_DIR.directory?
          PUBLICATION_DIR.mkpath
          puts 'Created directory', "   #{PUBLICATION_DIR}"
        end

        def init_mss
          sh 'scriv2tex', mss_source.to_s, PUBLICATION_DIR.to_s
          puts 'Extracted manuscript', "   from #{mss_source}", "   into #{PUBLICATION_DIR}/manuscript"
        end

        def init_yaml
          return puts "Already present, left unchanged: #{yaml_dest}" if yaml_dest.file?
          FileUtils.cp YAML_SOURCE.to_s, yaml_dest.to_s
          puts 'Created file', "   #{yaml_dest}"
        end

        def init_cover
          cover_dest.dirname.mkpath
          FileUtils.cp cover_source.to_s, cover_dest.to_s
          puts 'Copied cover image', "   from #{cover_source}", "   to #{cover_dest}"
        end

        def init_template
          [MINIMAL_TEMPLATE, template_name].uniq.each do |template_name|
            template_dir = template_dir(template_name)
            FileUtils.cp_r "#{template_dir}/.", PUBLICATION_DIR.to_s
            puts "Copied #{template_name} template files", "   from #{template_dir}", "   to #{PUBLICATION_DIR}"
          end
        end

        def list_templates
          TEMPLATES_DIR.each_child.select(&:directory?).each { |e| puts "   #{e.basename}" }
        end

        def declare_options(parser)
          parser.on('--cover [IMAGE_FILE]', Pathname, 'copy the ebook cover image') do |image_file|
            @cover = true
            @cover_source = image_file
          end

          parser.on('--mss [SCRIVENER_FILE]', Pathname, 'extract the mss from the Scrivener file') do |scrivener_file|
            @mss = true
            @mss_source = scrivener_file
          end

          parser.on('--template [NAME]', 'copy files from the template') do |name|
            @template = true
            @template_name = name
          end

          parser.on('--book DIR', Pathname, 'look in DIR for book mss and cover files') do |dir|
            @source_dir = dir
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
          check_cover_source(errors) if @cover
          check_mss_source(errors) if @mss
          check_template(errors) if @template
          check_yaml_dest(errors)
        end

        def check_cover_source(errors)
          return errors << "No such image file: #{cover_source}" unless cover_source.exist?
          errors << "Invalid image file: #{cover_source}" unless cover_source.file?
        end

        def check_mss_source(errors)
          return errors << "No such scrivener file: #{mss_source}" unless mss_source.exist?
          scrivx = mss_source / mss_source.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{mss_source}" unless scrivx.file?
        end

        def check_publication_dir(errors)
          return unless PUBLICATION_DIR.exist?
          return errors << "Invalid publication directory: #{PUBLICATION_DIR}" unless PUBLICATION_DIR.directory?
          return if @force
          errors << "Use --force to write into existing directory: #{PUBLICATION_DIR}" if PUBLICATION_DIR.directory?
        end

        def check_source_dir(errors)
          return errors << "No such source directory: #{source_dir}" unless source_dir.exist?
          errors << "Invalid source directory: #{source_dir}" unless source_dir.directory?
        end

        def check_template(errors)
          errors << "No such template: #{template_name}" unless template_dir(template_name).directory?
        end

        def check_yaml_dest(errors)
          return unless yaml_dest.exist?
          errors << "Existing publication.yaml file invalid: #{yaml_dest}" unless yaml_dest.file?
        end

        def cover_dest
          @cover_dest ||= PUBLICATION_DIR / 'epub/publication/cover.jpg'
        end

        def cover_source
          @cover_source ||= source_dir_cover || COVER_DEFAULT_SOURCE
        end

        def mss_source
          @mss_source ||= source_dir_mss
        end

        def slug
          @slug ||= source_dir.basename
        end

        def source_dir
          @source_dir ||= Pathname.pwd
        end

        def source_dir_cover
          [source_dir / 'covers' /"#{slug}-cover-2400.jpg"].select(&:file?).first
        end

        def source_dir_mss
          source_dir / 'mss' / slug.sub_ext('.scriv')
        end

        def template_dir(template_name)
          TEMPLATES_DIR / template_name
        end

        def template_name
          @template_name ||= MINIMAL_TEMPLATE
        end

        def yaml_dest
          @yaml_dest ||= PUBLICATION_DIR / 'publication.yaml'
        end
      end
    end
  end
end
