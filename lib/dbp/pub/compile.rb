require 'rake'
require 'rake/file_utils'

module DBP
  module Pub
    class Compile
      include FileUtils
      attr_reader :name

      def initialize
        @name = 'compile'
      end

      def run(options)
        env = {
            DBP_PUBLICATION_DIR: options.pub_dir,
            DBP_BUILD_DIR: options.tmp_dir,
            DBP_OUT_DIR: options.out_dir,
        }.map { |k, v| "#{k}=#{v.to_s}" }
        sh 'rake', '-f', options.rakefile.to_s, *options.targets, *env
      end

      def declare_options(parser, options)
        parser.banner << ' [target ...]'

        parser.on('--book BOOKDIR', Pathname, 'book directory') do |book_dir|
          options.book_dir = book_dir
        end

        parser.on('--pub PUBDIR', Pathname, 'publication directory') do |pub_dir|
          options.pub_dir = pub_dir
        end

        parser.on('--format FORMATDIR', Pathname, 'format directory') do |format_dir|
          options.format_dir = format_dir
        end

        parser.on('--tmp TMPDIR', Pathname, 'temporary build directory') do |tmp_dir|
          options.tmp_dir = tmp_dir
        end

        parser.on('--out OUTDIR', Pathname, 'output directory') do |out_dir|
          options.out_dir = out_dir
        end
      end

      def assign_unparsed_options(options)
        options.book_dir ||= Pathname.pwd
        options.tmp_dir ||= Pathname('/var/tmp/dbp')

        options.pub_dir ||= options.book_dir / 'publication'
        options.out_dir ||= options.book_dir / 'compiled'

        options.format_dir ||= format_dirs(options.book_dir).find { |d| d.directory? }
        options.rakefile = options.format_dir / 'Rakefile'

        options.targets = ARGV
      end

      def check_options(options, errors)
        errors << "Publication directory not found: #{options.pub_dir}" unless options.pub_dir.directory?
        errors << "No Rakefile in format directory: #{options.format_dir}" unless options.rakefile.file?
      end

      def format_dirs(book_dir)
        gem_data = Pathname(__FILE__) + '../../../../data'
        [
            book_dir / 'format',
            book_dir / '.format',
            gem_data / 'formats',
        ]
      end
    end
  end
end