require 'dbp/tex_to_markdown/translator'
require 'strscan'
require 'rake'
require 'rake/ext/pathname'

module DBP::BookCompiler::TexToMarkdown
  class App
    def initialize(options)
      source = options.source
      @tex_file_pattern = tex_file_pattern(source)
      @tex_path_to_md_path = "%{^#{source_dir(source)},#{options.dest}}X.md"
    end

    def run
      tex_files.each { |tex_in| translate(tex_in) }
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
      source.file? ? source : source / '**.*.tex'
    end

    def tex_files
      Pathname.glob(@tex_file_pattern)
    end

    def translate(tex_in)
      md_out = md_out(tex_in)
      md_out.dirname.mkpath
      md_out.open('w') do |writer|
        DBP::TexToMarkdown::Translator.new.translate(scanner(tex_in), writer)
      end
    end
  end
end