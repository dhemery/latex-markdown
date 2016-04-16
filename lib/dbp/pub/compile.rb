require_relative 'version'
require_relative 'cli'

require 'rake'
require 'rake/file_utils'

module DBP
  module Pub
    class Compile
      include FileUtils
      include CLI
      attr_reader :name

      def initialize
        @name = 'compile'
      end

      def run
        parse_command_line
        env = {
            DBP_PUBLICATION_DIR: @pub_dir,
            DBP_BUILD_DIR: @tmp_dir,
            DBP_OUT_DIR: @out_dir,
        }.map { |k, v| "#{k}=#{v.to_s}" }
        sh 'rake', '-f', @rakefile.to_s, *@targets, *env
      end

      def declare_options(parser)
        parser.banner << ' [target ...]'

        parser.on('--book BOOKDIR', Pathname, 'book directory') do |book_dir|
          @book_dir = book_dir
        end

        parser.on('--pub PUBDIR', Pathname, 'publication directory') do |pub_dir|
          @pub_dir = pub_dir
        end

        parser.on('--format FORMATDIR', Pathname, 'format directory') do |format_dir|
          @format_dir = format_dir
        end

        parser.on('--tmp TMPDIR', Pathname, 'temporary build directory') do |tmp_dir|
          @tmp_dir = tmp_dir
        end

        parser.on('--out OUTDIR', Pathname, 'output directory') do |out_dir|
          @out_dir = out_dir
        end
      end

      def assign_unparsed_options
        @book_dir ||= Pathname.pwd
        @tmp_dir ||= Pathname('/var/tmp/dbp')

        @pub_dir ||= @book_dir / 'publication'
        @out_dir ||= @book_dir / 'compiled'

        @format_dir ||= format_dirs.find { |d| d.directory? }
        @rakefile = @format_dir / 'Rakefile'

        @targets = ARGV
      end

      def check_options(errors)
        errors << "Publication directory not found: #{@pub_dir}" unless @pub_dir.directory?
        errors << "No Rakefile in format directory: #{@format_dir}" unless @rakefile.file?
      end

      def format_dirs
        gem_data = Pathname(__FILE__) + '../../../../data'
        [
            @book_dir / 'format',
            @book_dir / '.format',
            gem_data / 'formats',
        ]
      end
    end
  end
end