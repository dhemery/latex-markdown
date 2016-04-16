require 'dbp/pub/version'

require 'ostruct'
require 'optparse'
require 'pathname'

module DBP
  module Pub
    class CLI
      def initialize(app)
        @app = app
        @parser = parser
      end

      def help
        @parser.help
      end

      def name
        @app.name
      end

      def banner
        @parser.banner
      end

      def run
        parse_command_line
        @app.run
      end

      private

      def parse_command_line
        begin
          @parser.parse! ARGV
        rescue
          complain
        end
        @app.assign_unparsed_options
        errors = []
        @app.check_options(errors)
        complain(errors) unless errors.empty?
      end

      def complain(errors=[])
        puts 'Errors:', errors.map { |e| "   #{e}"}, '' unless errors.empty?
        puts help
        exit
      end

      def parser
        OptionParser.new.tap do |parser|
          parser.program_name = "#{Pathname($0).basename} #{name}"

          parser.accept(Pathname) { |p| Pathname(p) }

          parser.on_tail('--help', 'print this message') do
            puts parser
            exit
          end

          parser.on_tail('--version', 'print the version') do
            puts @app.version
            exit
          end

          @app.declare_options(parser)
        end
      end
    end
  end
end
