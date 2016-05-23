require_relative 'operator'

module DBP::BookCompiler::MarkdownToTex
  class Pop
    include Operator

    def operate(translator, captured)
      translator.pop
    end
  end
end