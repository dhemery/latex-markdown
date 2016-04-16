module DBP
  module Pub
    class Init
      TEMPLATES = %w[short-story]

      attr_reader :name

      def initialize
        @name = 'init'
      end

      def run(options)
        puts 'This command is not yet implemented. If it were implemented it would:'
        puts "    Delete #{options.pub_dir}" if options.pub_dir.directory?
        puts "    Create #{options.pub_dir}"
        puts "    Copy the #{options.template} template to #{options.pub_dir}"
        puts "    Add files from #{options.scriv} to #{options.pub_dir}" if options.scriv
      end

      def declare_options(parser, options)
        parser.banner << ' template [pub_dir]'

        parser.on('--force', 'remove <pub_dir> before initializing') do |force|
          options.force = force
        end

        parser.on('--scriv [SCRIV]', Pathname, 'initialize with a Scrivener file') do |scriv|
          options.scriv = scriv
        end

        parser.on('--list', 'list available templates') do |list|
          options.list = list
        end
      end

      def assign_unparsed_options(options)
        options.template = ARGV.shift
        options.pub_dir = ARGV.shift&.instance_eval { |d| Pathname(d) } || Pathname.pwd / 'publication'
      end

      def check_options(options, errors)
        check_template(options, errors)
        check_pub_dir(options, errors)
        check_scrivener_file(options, errors)
      end

      def check_scrivener_file(options, errors)
        return if options.scriv.nil?
        scriv = options.scriv
        errors << "No such scrivener file: #{scriv}" unless scriv.directory?
        scrivx = scriv / scriv.basename.sub_ext('.scrivx')
        errors << "Invalid scrivener file: #{scriv}" unless scrivx.file?
      end

      def check_pub_dir(options, errors)
        pub_dir = options.pub_dir
        return errors << "Refusing to overwrite the current working directory #{pub_dir}" if pub_dir.expand_path == Pathname.pwd
        errors << "Refusing to overwrite file #{pub_dir}" if pub_dir.file?
        return if options.force
        errors << "Refusing to overwrite existing #{pub_dir} without --force" if pub_dir.directory?
      end

      def check_template(options, errors)
        return errors << 'Missing template option' if options.template.nil?
        errors << "No such template: #{options.template.to_s}" unless TEMPLATES.include?(options.template)
      end
    end
  end
end
