
module DBP::BookCompiler::MarkdownToTex
  class Replace
    def initialize(replacements)
      @replacements= replacements
    end

    def execute(translator, input)
      translator.write(@replacements[input])
      translator.enter :copy_text
    end
  end
end