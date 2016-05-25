require_relative 'state'

module DBP::BookCompiler::MarkdownToTex
  class Translator
    BODY_TEXT = {
        pattern: /([^<*_]+)/,
        command: -> (translator, captured) { translator.write(captured) }
    }

    COMMENT_CONTENT = {
        pattern: /<!--\s*(.*?)\s*-->/,
        command: -> (translator, captured) { translator.write(captured) }
    }

    TOKENS = [
        BODY_TEXT,
        COMMENT_CONTENT,
    ]

    STATES = {
        executing_operator: State.new(TOKENS)
    }

    def initialize(reader, writer)
      @reader = reader
      @writer = writer
    end

    def translate
      transition_to(:executing_operator)
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