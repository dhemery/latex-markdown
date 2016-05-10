require_relative 'command.rb'

module DBP::BookCompiler::MarkdownToTex
  class CopyText
    include Command
    OUTER_TEXT = /[^<]*/

    def initialize
      @name = self.to_s
      @pattern = OUTER_TEXT

    end

    def write(writer, match)
      writer.write(match.matched)
    end

    def transition(translator, _)
      translator.resume(self)
      translator.read_tag
    end

    def to_s
      self.class.to_s
    end
  end
end