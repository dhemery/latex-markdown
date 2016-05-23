require_relative 'operator'

module DBP::BookCompiler::MarkdownToTex
  class Replace
    include Operator

    def initialize(replacements)
      @replacements= replacements
    end

    def operate(translator, captured)
      translator.write(@replacements[captured])
    end
  end
end