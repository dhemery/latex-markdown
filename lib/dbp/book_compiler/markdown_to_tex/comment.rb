require_relative 'command'

module DBP::BookCompiler::MarkdownToTex

  class Comment
    MARKDOWN_COMMENT_PATTERN = /[[:space:]]*(.*?)[[:space:]]*-->/
    include Command

    def initialize
      @name = '<!--'
      @pattern = MARKDOWN_COMMENT_PATTERN
    end

    def write(writer, match)
      writer.write(match[1])
    end
  end
end
