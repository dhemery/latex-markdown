module DBP::BookCompiler::MarkdownToTex
  class Translator
    BODY_TEXT = {
        pattern: /([^<*_]+)/,
        command: -> (translator, captured) { translator.write(captured) }
    }

    COMMENT_CONTENT = {
        pattern: /<!--\s*(.*?)\s*-->/,
        command: -> (translator, captured) { translator.write(captured) }
    }

    TOKENS = [
        BODY_TEXT,
        COMMENT_CONTENT,
    ]

    def initialize(scanner, writer, tokens = TOKENS)
      @scanner = scanner
      @writer = writer
      @tokens = tokens
    end

    def translate
      until @scanner.eos? do
        token = @tokens.find { |token| @scanner.scan(token[:pattern]) }
        token[:command].call(self, @scanner[1]) if token
      end
    end

    def write(text)
      @writer.write(text)
    end
  end
end
