require_relative 'command'

module DBP::BookCompiler::MarkdownToTex
  class OpenSpan
    include Command

    def initialize
      @name = '<span'
      @pattern = /\s+.*?class=['"]([[:alpha:]]+)['"].*?>/
    end

    def write(writer, match)
      writer.write("\\#{match[1]}{")
    end
  end
end