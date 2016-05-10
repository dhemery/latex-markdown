require_relative 'command.rb'

module DBP::BookCompiler::MarkdownToTex
  class ReadTag
    include Command
    TAG_PATTERN = /<!--|<[a-zA-Z]+/

    def initialize
      @name = self.to_s
      @pattern = TAG_PATTERN
    end

    def transition(translator, match)
      translator.execute_tag(match.matched)
    end

    def to_s
      self.class.to_s
    end
  end
end