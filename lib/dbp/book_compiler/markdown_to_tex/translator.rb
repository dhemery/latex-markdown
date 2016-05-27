module DBP::BookCompiler::MarkdownToTex
  class Translator
    TOKENS = {
        text: /([^<*_]+)/,
        emphasis: /(\*\*|_)/,
        open_tag: /<([a-z]+)\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,
        end_tag: /<\/.*?>/,
        void_tag: /<([a-z]+)\s*\/>/,
        comment: /<!--\s*(.*?)\s*-->/,
        unrecognized_text: /(.{1,80})/
    }

    EMPHASIS_BY_DELIMITER = {
        '_' => {
            macro: 'emph',
            enabled: false
        },
        '**' => {
            macro: 'bf',
            enabled: false
        }
    }

    REPLACEMENTS_BY_TAG_NAME = {
        'br' => '\break '
    }

    WRAPPERS_BY_TAG_NAME = {
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
      @emphasis = [false, false]
    end

    def translate
      until @scanner.eos? do
        token = TOKENS.each_key.find { |token| @scanner.scan(TOKENS[token]) }
        self.send(token, @scanner)
      end
    end

    def comment(captured)
      write captured[1]
    end

    def emphasis(captured)
      style = EMPHASIS_BY_DELIMITER[captured[1]]
      style[:enabled] = !style[:enabled]
      macro = style[:enabled] ? "\\#{style[:macro]}{" : '}'
      write macro
    end

    def end_tag(_)
      write @stack.pop
    end

    def open_tag(captured)
      tag_name = captured[1]
      class_value = captured[2]
      wrapper = WRAPPERS_BY_TAG_NAME[tag_name]
      write(wrapper[:before] % class_value)
      push(wrapper[:after] % class_value)
    end

    def text(captured)
      write captured[1]
    end

    def unrecognized_text(captured)
      raise "Unrecognized text starting with: #{captured[1]}"
    end

    def void_tag(captured)
      write REPLACEMENTS_BY_TAG_NAME[captured[1]]
    end

    def push(text)
      @stack.push text
    end

    def write(text)
      @writer.write(text)
    end
  end
end