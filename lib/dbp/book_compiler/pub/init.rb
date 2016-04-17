require 'dbp/book_compiler/util/cli'

module DBP
  module BookCompiler
    module Pub
      class Init
        include CLI
        TEMPLATES = %w[short-story]

        def initialize(command = nil)
          super command, 'init'
        end

        def run
          parse_command_line do |operands|
            @template = operands.shift
            @pub_dir = operands.shift&.instance_eval { |d| Pathname(d) } || Pathname.pwd / 'publication'
          end
          puts 'This command is not yet implemented. If it were implemented it would:'
          puts "    Delete #{@pub_dir}" if @pub_dir.directory?
          puts "    Create #{@pub_dir}"
          puts "    Copy the #{@template} template to #{@pub_dir}"
          puts "    Add files from #{@scriv} to #{@pub_dir}" if @scriv
        end

        def declare_options(parser)
          parser.banner << ' template [pub_dir]'

          parser.on('--force', 'remove <pub_dir> before initializing') do |force|
            @force = force
          end

          parser.on('--scriv [SCRIV]', Pathname, 'initialize with a Scrivener file') do |scriv|
            @scriv = scriv
          end

          parser.on('--list', 'list available templates') do |list|
            @list = list
          end
        end

        def check_options(errors)
          check_template(errors)
          check_pub_dir(errors)
          check_scrivener_file(errors)
        end

        def check_scrivener_file(errors)
          return if @scriv.nil?
          errors << "No such scrivener file: #{@scriv}" unless @scriv.directory?
          scrivx = @scriv / @scriv.basename.sub_ext('.scrivx')
          errors << "Invalid scrivener file: #{@scriv}" unless scrivx.file?
        end

        def check_pub_dir(errors)
          return errors << "Refusing to overwrite the current working directory #{@pub_dir}" if @pub_dir.expand_path == Pathname.pwd
          errors << "Refusing to overwrite file #{@pub_dir}" if @pub_dir.file?
          return if @force
          errors << "Refusing to overwrite existing #{@pub_dir} without --force" if @pub_dir.directory?
        end

        def check_template(errors)
          return errors << 'Missing template option' if @template.nil?
          errors << "No such template: #{@template}" unless TEMPLATES.include?(@template)
        end
      end
    end
  end
end