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

      private

      def parse_command_line
        begin
          parser.parse!
        # rescue
        #   complain
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

        @parser ||= OptionParser.new do |p|
          p.program_name = @full_name
          p.banner = "#{@full_name} [options]"

          p.accept(Pathname) { |p| Pathname(p) }

          p.on_tail('--help', 'print this message') do
            puts p
            exit
          end

          p.on_tail('--version', 'print the version') do
            puts version
            exit
          end

          declare_options(p)
        end
      end
    end
  end
end
