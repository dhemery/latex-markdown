module DBP
  module Pub
    class Init
      attr_reader :name

      TEMPLATES = %w[short-story]

      def initialize
        @name = 'init'
      end

      def run(options)
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
        options.pub_dir = ARGV.shift || Pathname.pwd
      end

      def check_options(options, errors)
        return errors << 'Missing template option' if options.template.nil?
        errors << "No such template: #{options.template.to_s}" unless TEMPLATES.include? options.template
      end
    end
  end
end
