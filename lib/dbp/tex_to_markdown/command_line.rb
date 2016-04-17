require 'dbp/book_compiler/version'

require 'optparse'
require 'ostruct'
require 'pathname'

module DBP
  module TexToMarkdown
    class CommandLine
      class << self
        def parse
          options = OpenStruct.new

          parser = OptionParser.new do |opts|
            opts.banner << ' source dest'

            opts.on_tail('--help', 'print this message') do
              puts opts
              exit
            end

            opts.on_tail('--version', 'print the version') do
              puts DBP::BookCompiler::VERSION::STRING
              exit
            end
          end

          begin
            parser.parse! ARGV
          rescue
            puts parser
            exit
          end

          unless ARGV.length == 2
            puts parser
            exit
          end

          options.source = Pathname(ARGV[0])
          options.dest = Pathname(ARGV[1])

          validate_options(options)

          options
        end

        def validate_options(options)
          errors = []
          errors << "#{options.source}: no such file or directory" unless options.source.exist?
          errors << "#{options.dest}: is a file" if options.dest.file?
          abort(errors) unless errors.empty?
        end
      end
    end
  end
end