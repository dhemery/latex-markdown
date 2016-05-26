module DBP::BookCompiler::MarkdownToTex
  class Translator
    BODY_TEXT = {
        pattern: /([^<*_]+)/,
        command: -> (translator, captured) { translator.write(captured) }
    }

    BR_TAG = {
        pattern: /<br\s*\/>/,
        command: -> (translator, _) { translator.write('\break ') }
    }

    COMMENT_CONTENT = {
        pattern: /<!--\s*(.*?)\s*-->/,
        command: -> (translator, capture) { translator.write(capture) }
    }

    # Matches any text and raises an error.
    # Match against this last to catch otherwise unmatched pattern.
    UNRECOGNIZED = {
        pattern: /(.{1,80})/,
        command: -> (_, capture) { raise "Unrecognized text starting with: #{capture}" }
    }

    TOKENS = [
        BODY_TEXT,
        COMMENT_CONTENT,
        BR_TAG,
        UNRECOGNIZED,
    ]

    def initialize(scanner, writer, tokens = TOKENS)
      @scanner = scanner
      @writer = writer
      @tokens = tokens
    end

    def translate
      until @scanner.eos? do
        token = @tokens.find { |token| @scanner.scan(token[:pattern]) }
        token[:command].call(self, @scanner[1])
      end
    end

    def write(text)
      @writer.write(text)
    end
  end
end
