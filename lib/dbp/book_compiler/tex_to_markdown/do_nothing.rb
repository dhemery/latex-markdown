require_relative 'command.rb'

module DBP::BookCompiler::TexToMarkdown
  class DoNothing
    include Command

    def initialize(name)
      @name = name
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end