require 'dbp/compile/version'

require 'ostruct'
require 'optparse'
require 'pathname'

module DBP
  module Init
    class CommandLine
      class << self
        def parse
          options = OpenStruct.new

          parser = OptionParser.new do |opts|
            opts.banner << ' template [pubdir]'

            opts.accept(Pathname) { |p| Pathname(p) }

            opts.on('--force', 'remove <pubdir> before initializing') do |force|
              options.force = force
            end

            opts.on('--scriv [SCRIV]', Pathname, 'initialize with a Scrivener file') do |scriv|
              options.scriv = scriv
            end

            opts.on('--list', 'list available templates') do |list|
              options.list = list
            end

            opts.on_tail('--help', 'print this message') do
              puts opts
              exit
            end

            opts.on_tail('--version', 'print the version') do
              puts DBP::Compile::VERSION::STRING
              exit
            end
          end

          parser.accept(Pathname) { |p| Pathname(p) }

          begin
            parser.parse! ARGV
          rescue
            puts parser
            exit
          end

          options.template = ARGV[0]
          options.pubdir = ARGV[1] || Pathname.pwd

          puts "Options:"
          options.each_pair { |k,v| puts "    #{k}: #{v}"}
          options
        end

        def installed_templates
          ['short-story']
        end
      end
    end
  end
end
