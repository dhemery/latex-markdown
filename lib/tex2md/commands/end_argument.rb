require_relative 'command.rb'

module TeX2md
  class EndArgument
    include Command

    def initialize
      @name = '}'
    end

    def transition(translator, _)
      translator.finish_command # the command that the macro interrupted
    end

    def to_s
      "#{self.class}"
    end
  end
end