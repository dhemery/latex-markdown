require_relative 'operator'

module DBP::BookCompiler::MarkdownToTex
  class Toggle
    include Operator

    def initialize(toggles)
      @toggles = toggles.reduce({}) { |h,w| h[w[:name]] = w; h }
    end

    def operate(translator, captured)
      toggle = @toggles[captured]
      toggle[:enabled] = !toggle[:enabled]
      text = toggle[:enabled] ? "\\#{toggle[:macro]}{" : '}'
      translator.write(text)
    end
  end
end