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
        PUBLICATION_YAML_SOURCE = TEMPLATES_DIR / 'publication.yaml'
        COVER_DEFAULT_SOURCE = TEMPLATES_DIR / 'cover.jpg'
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
          puts "Created #{PUBLICATION_DIR}"
        end

        def init_mss
          sh 'scriv2tex', mss_source.to_s, PUBLICATION_DIR.to_s
          puts "Translated manuscript from: #{mss_source}"
        end

        def init_yaml
          return if yaml_dest.file?
          FileUtils.cp PUBLICATION_YAML_SOURCE.to_s, yaml_dest.to_s
          puts "Created #{yaml_dest}"
        end

        def init_cover
          cover_dest.dirname.mkpath
          FileUtils.cp cover_source.to_s, cover_dest.to_s

          puts 'Copied cover image file', "   from #{cover_source}", "   to #{cover_dest}"
        end

        def init_template
          [MINIMAL_TEMPLATE, template_name].uniq.each do |template_name|
            FileUtils.cp_r "#{TEMPLATES_DIR / template_name}/.", PUBLICATION_DIR.to_s
            puts "Copied template #{template_name}"
          end
        end

        def list_templates
          TEMPLATES_DIR.each_child.select(&:directory?).each { |e| puts "   #{e.basename}" }
        end

        def declare_options(parser)
          parser.on('--template [NAME]', 'copy files from a template') do |name|
            @template = true
            @template_name = name
          end

          parser.on('--cover [IMAGE_FILE]', Pathname, 'copy a cover image file') do |image_file|
            @cover = true
            @cover_source = image_file
          end

          parser.on('--mss [SCRIVENER_FILE]', Pathname, 'translate a Scrivener file as a manuscript') do |scrivener_file|
            @mss = true
            @mss_source = scrivener_file
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
          return errors << "No such cover image file: #{cover_source}" unless cover_source.exist?
          errors << "Cover source is a directory: #{cover_source}" if cover_source.directory?
        end

        def check_mss_source(errors)
          return errors << "No such scrivener file: #{mss_source}" unless mss_source.exist?
          scrivx = mss_source / mss_source.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{mss_source}" unless scrivx.file?
        end

        def check_publication_dir(errors)
          errors << "#{PUBLICATION_DIR} is a file" if PUBLICATION_DIR.file?
          return if @force
          errors << "Use --force to write into existing directory: #{PUBLICATION_DIR}" if PUBLICATION_DIR.directory?
        end

        def check_template(errors)
          template_dir = TEMPLATES_DIR / template_name
          errors << "No such template: #{template_name}" unless template_dir.directory?
        end

        def check_yaml_dest(errors)
          errors << "#{yaml_dest} is a directory" if yaml_dest.directory?
        end

        def cover_dest
          @cover_dest ||= PUBLICATION_DIR / 'epub/publication/cover.jpg'
        end

        def cover_source
          @cover_source ||= cover_local_source || COVER_DEFAULT_SOURCE
        end

        def cover_local_source
          [Pathname("covers/#{slug}-cover-2400.jpg")].select(&:file?).first
        end

        def mss_source
          @mss_source ||= mss_local_source
        end

        def mss_local_source
          Pathname('mss') / slug.sub_ext('.scriv')
        end

        def slug
          @slug ||= Pathname.pwd.basename
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
