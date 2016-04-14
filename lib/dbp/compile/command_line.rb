require 'dbp/compile/version'

require 'ostruct'
require 'optparse'
require 'pathname'

module DBP
  module Compile
    class CommandLine
      class << self
        def parse
          options = OpenStruct.new

          parser = OptionParser.new do |opts|
            opts.banner << ' [target ...]'

            opts.accept(Pathname) { |p| Pathname(p) }

            opts.on('--book [BOOKDIR]', Pathname, 'book directory') do |book_dir|
              options.book_dir = book_dir
            end

            opts.on('--pub [PUBDIR]', Pathname, 'publication directory') do |pub_dir|
              options.pub_dir = pub_dir
            end

            opts.on('--format [FORMATDIR]', Pathname, 'format directory') do |format_dir|
              options.format_dir = format_dir
            end

            opts.on('--tmp [TMPDIR]', Pathname, 'temporary build directory') do |tmp_dir|
              options.tmp_dir = tmp_dir
            end

            opts.on('--out [OUTDIR]', Pathname, 'output directory') do |out_dir|
              options.out_dir = out_dir
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

          begin
            parser.parse! ARGV
          rescue
            puts parser
            exit
          end

          options.targets = ARGV
          puts "Options:"
          options.each_pair { |k,v| puts "    #{k}: #{v}"}
          options
        end

        def format_dirs
          gem_data = Pathname(__FILE__) + '../../data'

          book_dir = Pathname.pwd
          [book_dir / 'format', book_dir / '.format', gem_data / 'formats']
        end
      end
    end
  end
end
