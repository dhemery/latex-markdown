require_relative 'operator'

module DBP::BookCompiler::MarkdownToTex
  class Write
    include Operator

    def operate(translator, captured)
      translator.write(captured)
    end
  end
end