require 'ostruct'
require 'optparse'

module DBP
  module ScrivenerToTex
    class CommandLine
      def self.parse
        options = OpenStruct.new

        parser = OptionParser.new do |opts|
          opts.banner << ' file dir'

          opts.on_tail('-h', '--help', 'print this message') do
            puts opts
            exit
          end
        end

        parser.parse! ARGV

        unless ARGV.length == 2
          puts parser
          exit
        end

        options.scrivener_file = Pathname(ARGV[0])
        options.output_dir = Pathname(ARGV[1])

        abort "No such scrivener file: #{options.scrivener_file}" unless options.scrivener_file.directory?

        options
      end
    end
  end
end
