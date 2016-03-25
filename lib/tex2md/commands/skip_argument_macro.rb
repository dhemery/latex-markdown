require_relative 'command.rb'

module TeX2md
  class SkipArgumentMacro
    include Command

    def initialize(name)
      @name = name
      @pattern = /{/
    end

    def transition(translator, _)
      translator.skip_argument
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end