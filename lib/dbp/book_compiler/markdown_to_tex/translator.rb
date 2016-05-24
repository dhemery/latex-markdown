require_relative 'states/copying_text'

module DBP::BookCompiler::MarkdownToTex
  class Translator
    STATES = {
        copying_text: CopyingText.new
    }

    def initialize(reader, writer)
      @reader = reader
      @writer = writer
    end

    def translate
      transition_to(:copying_text)
      @state.enter(self, @reader)
    end

    def write(text)
      @writer.write(text)
    end

    def transition_to(state)
      @state = STATES[state]
    end
  end
end