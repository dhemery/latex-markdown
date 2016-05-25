require_relative 'state'

module DBP
  module BookCompiler
    module MarkdownToTex
      class State
        def initialize(tokens)
          @tokens = tokens
        end

        def enter(translator, scanner)
          token = @tokens.find { |token| scanner.scan(token[:pattern]) }
          token[:command].call(translator, scanner[1]) if token
          translator.transition_to(:end) if scanner.eos?
        end
      end
    end
  end
end
