require_relative 'command.rb'

module DBP
  module TeX2md
    class ExecuteCommand
      include Command

      def initialize(pattern)
        @name = '\\'
        @pattern = pattern
      end

      def transition(translator, command_name)
        translator.execute_command(command_name)
      end

      def to_s
        "#{self.class}(#{name},#{pattern.source})"
      end
    end
  end
end