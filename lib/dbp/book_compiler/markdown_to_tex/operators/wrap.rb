require_relative 'operator'

module DBP::BookCompiler::MarkdownToTex
  class Wrap
    include Operator

    def initialize(wrappers)
      @wrappers = wrappers.reduce({}) { |h,w| h[w[:name]] = w; h }
    end

    def operate(translator, captured)
      wrapper = @wrappers[captured]
      translator.write(wrapper[:open] % captured)
      translator.push(wrapper[:close] % captured)
    end
  end
end