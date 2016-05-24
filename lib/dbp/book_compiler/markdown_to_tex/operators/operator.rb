module DBP
  module BookCompiler
    module MarkdownToTex
      module Operator
        def execute(translator, captured)
          operate(translator, captured)
          translator.enter :copying_text
        end
      end
    end
  end
end
