require 'dbp/book_compiler/markdown_to_tex/translator'
require 'pathname'
require 'strscan'
require 'rake'
require 'rake/ext/string'

require 'dbp/book_compiler/util/cli'

module DBP
  module BookCompiler
    class Md2TeX
      include CLI

      def initialize
        super 'md2tex'
      end

      def run
        parse_command_line do |operands|
          complain unless operands.length == 2
          @source = operands.shift&.instance_eval { |s| Pathname(s) }
          @dest= operands.shift&.instance_eval { |s| Pathname(s) }
        end
        @md_file_pattern = md_file_pattern(@source)
        @md_path_to_tex_path = "%{^#{source_dir(@source)},#{@dest}}X.tex"
        md_files.each { |md_path| translate(md_path) }
      end

      def declare_options(p)
        p.banner << ' source dest'
      end

      def check_options(errors)
        errors << "#{@source}: no such file or directory" unless @source&.exist?
        errors << "#{@dest}: is a file" if @dest&.file?
      end

      private

      def md_file_pattern(source)
        source.file? ? source : source / '**' / '*.md'
      end

      def md_files
        Pathname.glob(@md_file_pattern)
      end

      def scanner(md_in)
        StringScanner.new(md_in.read)
      end

      def source_dir(source)
        source.directory? ? source : source.dirname
      end

      def to_tex_path(md_path)
        Pathname(md_path.to_s.pathmap(@md_path_to_tex_path))
      end

      def translate(md_path)
        tex_out = to_tex_path(md_path)
        tex_out.dirname.mkpath
        tex_out.open('w') do |writer|
          MarkdownToTex::Translator.new(scanner(md_path), writer).translate
        end
      end
    end
  end
end