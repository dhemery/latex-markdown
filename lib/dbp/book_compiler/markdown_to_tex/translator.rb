require_relative 'states/copying_text'

module DBP::BookCompiler::MarkdownToTex
  class Translator
    OPERATORS = [
        {
            names: ['!--'],
            pattern: '<(!--)[[:space:]]*(.*?)[[:space:]]*-->',
            command: -> (t, _, arg) { t.write(arg) }
        }
    ]
    STATES = {
        copying_text: CopyingText.new,
        executing_operator: ExecutingOperator.new(OPERATORS)
    }

    def initialize(reader, writer)
      @reader = reader
      @writer = writer
    end

    def translate
      transition_to(:copying_text)
      @state.enter(self, @reader) until @state.nil?
    end

    def write(text)
      @writer.write(text)
    end

    def transition_to(state)
      @state = STATES[state]
    end
  end
end