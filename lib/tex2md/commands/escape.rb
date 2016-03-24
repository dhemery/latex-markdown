require_relative 'command.rb'

module TeX2md
  class Escape
    include Command

    def initialize
      @name = '\\'
    end

    def transition(translator, _)
      translator.read_macro
    end

    def to_s
      "#{self.class}"
    end
  end
end