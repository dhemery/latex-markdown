require_relative 'command.rb'

module DBP::BookCompiler::TexToMarkdown
  class DiscardNumericArgument
    include Command

    def initialize(name)
      @name = name
      @pattern = /-?([[:digit:]]*)/
    end
  end
end