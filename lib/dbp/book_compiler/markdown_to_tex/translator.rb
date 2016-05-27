module DBP::BookCompiler::MarkdownToTex
  class Translator
    TOKENS = {
        # text with no operators -> copy
        copy: /([^<*_]+)/,

        # tag.class -> enter
        enter: /<([a-z]+)\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,

        # any end tag -> exit
        exit: /<\/.*?>/,

        # comment -> extract
        extract: /<!--\s*(.*?)\s*-->/,

        # void tag (currently only <br/>) -> replace
        replace: /<(br)\s*\/>/,

        # any other text -> reject
        reject: /(.{1,80})/,
    }

    # void tags (e.g. <br />) are replaced by fixed text
    REPLACEMENTS = {
        'br' => '\break '
    }

    # start tags (e.g, <div> and <span>) enter a macro or environment
    WRAPPERS = {
        'div' => {
            before: '\begin{%s}',
            after: '\end{%s}'
        },
        'span' => {
            before: '\%s{',
            after: '}'
        },
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

    def copy(captured)
      write captured[1]
    end

    def enter(captured)
      tag = captured[1]
      name = captured[2]
      wrapper = WRAPPERS[tag]
      write(wrapper[:before] % name)
      push(wrapper[:after] % name)
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