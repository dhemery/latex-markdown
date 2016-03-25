require_relative 'command.rb'

module TeX2md
  class BeginEnvironment
    include Command

    def initialize
      @name = 'begin'
      @pattern = /{/
    end

    def transition(translator, _)
      translator.read_macro
    end

    def to_s
      "#{self.class}"
    end
  end
end