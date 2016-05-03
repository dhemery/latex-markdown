require 'dbp'
require 'dbp/book_compiler/util/cli'

require 'rake'
require 'rake/file_utils'

module DBP
  module BookCompiler
    module Pub
      class Compile
        include FileUtils
        include BookCompiler::CLI
        attr_reader :targets

        def initialize(command = nil)
          super command, 'compile'
        end

        def run
          parse_command_line do |operands|
            @targets = operands
          end
          env = {
              DBP_PUBLICATION_DIR: pub_dir,
              DBP_BUILD_DIR: tmp_dir,
              DBP_OUT_DIR: out_dir,
          }.map { |k, v| "#{k}=#{v.to_s}" }
          sh 'rake', *env, '-f', rakefile.to_s, *targets
        end

        def book_dir
          @book_dir ||= Pathname.pwd
        end

        def format_dir
          @format_dir ||= format_dirs.find { |d| d.directory? }
        end

        def out_dir
          @out_dir ||= book_dir / 'compiled'
        end

        def pub_dir
          @pub_dir ||= book_dir / 'publication'
        end

        def rakefile
          @rakefile = format_dir / 'Rakefile'
        end

        def tmp_dir
          @tmp_dir ||= Pathname('/var/tmp/dbp')
        end

        def declare_options(parser)
          parser.banner << ' [target ...]'

          parser.on('--book BOOKDIR', Pathname, 'Book directory') do |book_dir|
            @book_dir = book_dir
          end

          parser.on('--pub PUBDIR', Pathname, 'Publication directory') do |pub_dir|
            @pub_dir = pub_dir
          end

          parser.on('--format FORMATDIR', Pathname, 'Format directory') do |format_dir|
            @format_dir = format_dir
          end

          parser.on('--tmp TMPDIR', Pathname, 'Temporary build directory') do |tmp_dir|
            @tmp_dir = tmp_dir
          end

          parser.on('--out OUTDIR', Pathname, 'Output directory') do |out_dir|
            @out_dir = out_dir
          end
        end

        def check_options(errors)
          errors << "Publication directory not found: #{pub_dir}" unless pub_dir.directory?
          errors << "No Rakefile in format directory: #{rakefile.dirname}" unless rakefile.file?
        end

        def format_dirs
          [
              book_dir / 'compilers',
              book_dir / '.compilers',
              DBP.data_dir / 'compilers',
          ]
        end
      end
    end
  end
end
