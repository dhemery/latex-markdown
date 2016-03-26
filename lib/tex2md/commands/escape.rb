require_relative 'command.rb'

module TeX2md
  class Escape
    include Command

    def initialize
      @name = '\\'
      @pattern = /[[:alpha:]]+/
    end

    def transition(translator, macro)
      translator.execute_command(macro)
    end

    def to_s
      "#{self.class}"
    end
  end
end