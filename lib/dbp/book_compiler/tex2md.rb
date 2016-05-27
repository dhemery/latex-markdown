require 'dbp/book_compiler/tex_to_markdown/translator'
require 'strscan'
require 'rake'
require 'rake/ext/pathname'

require 'dbp/book_compiler/util/cli'

module DBP
  module BookCompiler
    class TeX2Md
      include CLI

      def initialize
        super 'tex2md'
      end

      def run
        parse_command_line do |operands|
          complain unless operands.length == 2
          @source = operands.shift&.instance_eval { |s| Pathname(s) }
          @dest= operands.shift&.instance_eval { |s| Pathname(s) }
        end
        @tex_file_pattern = tex_file_pattern(@source)
        @tex_path_to_md_path = "%{^#{source_dir(@source)},#{@dest}}X.md"
        tex_files.each { |tex_in| translate(tex_in) }
      end

      def declare_options(p)
        p.banner << ' source dest'
      end

      def check_options(errors)
        errors << "#{@source}: no such file or directory" unless @source&.exist?
        errors << "#{@dest}: is a file" if @dest&.file?
      end

      private

      def md_out(tex_in)
        tex_in.pathmap(@tex_path_to_md_path)
      end

      def scanner(tex_in)
        StringScanner.new(tex_in.read)
      end

      def source_dir(source)
        source.directory? ? source : source.dirname
      end

      def tex_file_pattern(source)
        source.file? ? source : source / '**' / '*.tex'
      end

      def tex_files
        Pathname.glob(@tex_file_pattern)
      end

      def translate(tex_in)
        md_out = md_out(tex_in)
        md_out.dirname.mkpath
        md_out.open('w') do |writer|
          TexToMarkdown::Translator.new.translate(scanner(tex_in), writer)
        end
      end
    end
  end
end