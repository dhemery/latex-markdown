require_relative 'command.rb'

module TeX2md
  class ReadCommand
    include Command

    def initialize(pattern)
      @pattern = pattern
    end

    def transition(translator, command_name)
      translator.execute_command(command_name)
    end

    def to_s
      "#{self.class}#{@pattern.source}"
    end
  end
end