require_relative 'state'

module DBP
  module BookCompiler
    module MarkdownToTex
      module State

        attr_reader :pattern, :next_state

        def enter(translator, scanner)
          scanner.scan(pattern)

          respond(translator, scanner)

          if scanner.eos?
            translator.transition_to(:end)
          else
            translator.transition_to(next_state)
          end
        end
      end
    end
  end
end
