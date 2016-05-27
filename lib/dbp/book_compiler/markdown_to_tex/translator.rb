require 'yaml'

module DBP
  module BookCompiler
    module MarkdownToTex
      class Translator
        TOKENS = {
            yaml_header: /---\s*\n.*?\n\.\.\./m,
            text: /[^<*_]+/,
            emphasis: /\*\*|_/,
            open_tag: /<([a-z]+)\s+class\s*=\s*"\s*([^[:space:]]+)\s*"\s*>/,
            end_tag: /<\/([a-z]+)\s*>/,
            void_tag: /<([a-z]+)\s*\/>/,
            comment: /<!--\s*(.*?)\s*-->/,
            unrecognized_text: /.{1,80}/
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

        ENVIRONMENT_TYPES_BY_TAG_NAME = {
            'div' => {
                enter: '\begin{%s}',
                exit: '\end{%s}'
            },
            'span' => {
                enter: '\%s{',
                exit: '}'
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

        def comment(captured)
          write captured[1]
        end

        def emphasis(captured)
          style = EMPHASIS_BY_DELIMITER[captured.matched]
          style[:enabled] = !style[:enabled]
          macro = style[:enabled] ? "\\#{style[:macro]}{" : '}'
          write macro
        end

        def end_tag(_)
          write @stack.pop
        end

        def open_tag(captured)
          type = ENVIRONMENT_TYPES_BY_TAG_NAME[captured[1]]
          name = captured[2]
          write(type[:enter] % name)
          push(type[:exit] % name)
        end

        def text(captured)
          write captured.matched
        end

        def unrecognized_text(captured)
          raise "Unrecognized text starting with: #{captured.matched}"
        end

        def void_tag(captured)
          write REPLACEMENTS_BY_TAG_NAME[captured[1]]
        end

        def yaml_header(captured)
          yaml = YAML.load(captured.matched)
          write "\\#{yaml['style']}{#{yaml['title']}}"
        end

        def push(text)
          @stack.push text
        end

        def write(text)
          @writer.write(text)
        end
      end
    end
  end
end
