require 'dbp/pub/version'

require 'ostruct'
require 'optparse'
require 'pathname'

module DBP
  module Pub
    module CLI
      def help
        parser.help
      end

      def banner
        parser.banner
      end

      def version
        DBP::Pub::VERSION::STRING
      end

      private

      def parse_command_line
        begin
          parser.parse!
        rescue
          complain
        end
        assign_unparsed_options
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
        @parser ||= ARGV.options.tap do |p|
          p.program_name = "#{Pathname($0).basename} #{name}"

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
