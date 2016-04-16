require 'dbp/pub/version'

require 'ostruct'
require 'optparse'
require 'pathname'

module DBP
  module Pub
    class Command
      def initialize(app)
        @app = app
        @options = OpenStruct.new
        @parser = parser
      end

      def help
        @parser.to_s
      end

      def name
        @app.name
      end

      def options
        parse_command_line unless @parsed
        @options
      end

      def run
        @app.run(options)
      end

      private

      def assign_unparsed_options
        @app.assign_unparsed_options(@options)
      end

      def check_options
        errors = []
        @app.check_options(@options, errors)
        complain(errors) unless errors.empty?
      end

      def parse_command_line
        begin
          parser.parse! ARGV
        rescue
          complain
        end
        @parsed = true
        assign_unparsed_options
        check_options
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
            puts @options
            exit
          end

          parser.on_tail('--version', 'print the version') do
            puts DBP::Pub::VERSION::STRING
            exit
          end

          @app.declare_options(parser, @options)
        end
      end
    end
  end
end
