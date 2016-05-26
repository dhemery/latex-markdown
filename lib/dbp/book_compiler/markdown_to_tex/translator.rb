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

    DIV_START_TAG = {
        pattern: /<div\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,
        command: -> (translator, capture) { translator.enter_environment(capture) }
    }

    END_TAG = {
        pattern: /<\/.*?>/,
        command: -> (translator, _) { translator.pop }
    }

    # Matches any text and raises an error.
    # Match against this last to catch otherwise unmatched pattern.
    UNRECOGNIZED = {
        pattern: /(.{1,80})/,
        command: -> (_, capture) { raise "Unrecognized text starting with: #{capture}" }
    }

    TOKENS = [
        BODY_TEXT,
        BR_TAG,
        COMMENT_CONTENT,
        DIV_START_TAG,
        END_TAG,
        UNRECOGNIZED,
    ]

    def initialize(scanner, writer, tokens = TOKENS)
      @scanner = scanner
      @writer = writer
      @tokens = tokens
      @stack = []
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

    def enter_environment(name)
      write "\\begin{#{name}}"
      push "\\end{#{name}}"
    end

    def pop
      write @stack.pop
    end

    def push(text)
      @stack.push text
    end
  end
end