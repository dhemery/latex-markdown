require 'optparse'
require 'ostruct'
require 'pathname'

require 'tex2md/version'

module TeX2md
  class CommandLine
    def self.parse
      options = OpenStruct.new

      parser = OptionParser.new do |opts|
        opts.banner << ' source dest'

        opts.on_tail('--help', 'print this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'print the version') do
          puts "#{TeX2md::VERSION}"
          exit
        end
      end

      parser.parse!(ARGV)

      unless ARGV.length == 2
        puts parser
        exit
      end

      options.source = Pathname(ARGV[0])
      options.dest = Pathname(ARGV[1])

      options
    end
  end
end