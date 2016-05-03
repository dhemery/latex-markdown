require 'dbp/book_compiler/version'

require 'optparse'
require 'pathname'

module DBP
  module BookCompiler
    module CLI
      attr_reader :name

      def initialize(*names)
        @full_name = names.reject { |n| n.nil? }.join(' ')
        @name = names.last
      end

      def help
        "Usage: #{parser.help}"
      end

      def banner
        parser.banner
      end

      def version
        DBP::BookCompiler::VERSION::STRING
      end

      def declare_options(parser)
      end

      def check_options(errors)
      end

      private

      def parse_command_line
        begin
          parser.parse!
        rescue
          complain
        end
        yield ARGV if block_given?
        errors = []
        check_options(errors)
        complain(errors) unless errors.empty?
      end

      def complain(errors=[])
        puts 'Errors:', errors.map { |e| "   #{e}"}, '' unless errors.empty?
        puts help
        exit
      end

      def parser

        @parser ||= OptionParser.new do |parser|
          parser.program_name = @full_name
          parser.banner = "#{@full_name} [options]"

          parser.accept(Pathname) { |path| Pathname(path) }

          parser.on_tail('--help', 'Print this message and exit') do
            puts parser
            exit
          end

          parser.on_tail('--version', 'Print the version and exit') do
            puts version
            exit
          end

          declare_options(parser)
        end
      end
    end
  end
end
