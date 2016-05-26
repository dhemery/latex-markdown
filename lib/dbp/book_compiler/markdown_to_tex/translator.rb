module DBP::BookCompiler::MarkdownToTex
  class Translator
    TOKENS = {
        # span.class -> call
        call: /<span\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,

        # text with no operators -> copy
        copy: /([^<*_]+)/,

        # div.class -> enter
        enter: /<div\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,

        # any end tag -> exit
        exit: /<\/.*?>/,

        # comment -> extract
        extract: /<!--\s*(.*?)\s*-->/,

        # void tag (currently only <br/>) -> replace
        replace: /<(br)\s*\/>/,

        # any other text -> reject
        reject: /(.{1,80})/,
    }

    REPLACEMENTS = {
        'br' => '\break '
    }

    def initialize(scanner, writer)
      @scanner = scanner
      @writer = writer
      @stack = []
    end

    def translate
      until @scanner.eos? do
        token = TOKENS.each_key.find { |token| @scanner.scan(TOKENS[token]) }
        self.send(token, @scanner)
      end
    end

    def call(captured)
      write "\\#{captured[1]}{"
      push '}'
    end

    def copy(captured)
      write captured[1]
    end

    def enter(captured)
      write "\\begin{#{captured[1]}}"
      push "\\end{#{captured[1]}}"
    end

    def exit(_)
      write @stack.pop
    end

    def extract(captured)
      write captured[1]
    end

    def reject(captured)
      raise "Unrecognized text starting with: #{captured[1]}"
    end

    def replace(captured)
      write REPLACEMENTS[captured[1]]
    end

    def push(text)
      @stack.push text
    end

    def write(text)
      @writer.write(text)
    end
  end
end