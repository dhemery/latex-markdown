module DBP::BookCompiler::MarkdownToTex
  class Translator
    TOKENS = {
        # text with no operators -> copy
        copy: /([^<*_]+)/,

        # div.class -> enter the environment named by .class
        enter: /<div\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,

        # any end tag -> exit the current environment or macro
        exit: /<\/.*?>/,

        # comment -> extract the content
        extract: /<!--\s*(.*?)\s*-->/,

        # void tag (currently only <br/>) -> replace with text from REPLACEMENTS
        replace: /<(br)\s*\/>/,

        # any other text -> fail with a diagnostic
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
        self.send(token, @scanner[1])
      end
    end

    def enter(name)
      write "\\begin{#{name}}"
      push "\\end{#{name}}"
    end

    def exit(_)
      write @stack.pop
    end

    def reject(text)
      raise "Unrecognized text starting with: #{text}"
    end

    def replace(text)
      write REPLACEMENTS[text]
    end

    def push(text)
      @stack.push text
    end

    def write(text)
      @writer.write(text)
    end

    alias_method :copy, :write
    alias_method :extract, :write
  end
end