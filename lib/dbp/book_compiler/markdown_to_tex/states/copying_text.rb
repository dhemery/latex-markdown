require_relative 'state'

module DBP::BookCompiler::MarkdownToTex
  class CopyingText
    include State

    def initialize
      @pattern = /[^<*_]*/
      @next_state = :executing_operator
    end

    def respond(translator, scanned)
      translator.write(scanned[0])
    end
  end
end