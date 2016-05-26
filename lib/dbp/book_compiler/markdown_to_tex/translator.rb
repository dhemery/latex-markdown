module DBP::BookCompiler::MarkdownToTex
  class Translator
    BODY_TEXT = {
        pattern: /([^<*_]+)/,
        command: :write
    }

    BR_TAG = {
        pattern: /<(br)\s*\/>/,
        command: :replace
    }

    COMMENT_CONTENT = {
        pattern: /<!--\s*(.*?)\s*-->/,
        command: :write
    }

    DIV_START_TAG = {
        pattern: /<div\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,
        command: :enter_environment
    }

    END_TAG = {
        pattern: /<\/.*?>/,
        command: :pop
    }

    # Matches any text and raises an error.
    # Match against this last to catch otherwise unmatched pattern.
    UNRECOGNIZED = {
        pattern: /(.{1,80})/,
        command: :fail
    }

    TOKENS = [
        BODY_TEXT,
        BR_TAG,
        COMMENT_CONTENT,
        DIV_START_TAG,
        END_TAG,
        UNRECOGNIZED,
    ]

    REPLACEMENT = {
        'br' => '\break '
    }

    def initialize(scanner, writer, tokens = TOKENS)
      @scanner = scanner
      @writer = writer
      @tokens = tokens
      @stack = []
    end

    def translate
      until @scanner.eos? do
        token = @tokens.find { |token| @scanner.scan(token[:pattern]) }
        self.send(token[:command], @scanner[1])
      end
    end

    def enter_environment(name)
      write "\\begin{#{name}}"
      push "\\end{#{name}}"
    end

    def fail(text)
      raise "Unrecognized text starting with: #{text}"
    end

    def pop(_)
      write @stack.pop
    end

    def push(text)
      @stack.push text
    end

    def replace(text)
      write REPLACEMENT[text]
    end

    def write(text)
      @writer.write(text)
    end
  end
end