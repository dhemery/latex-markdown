require_relative 'command.rb'

module DBP
  module TeX2md
    class ExitEnvironment
      include Command
      attr_reader :text

      def initialize
        @name = 'end'
        @pattern = /{([[:alpha:]]+)}/
        @text = '</div>'
      end

      def write(writer, _)
        writer.write(text)
      end

      def transition(translator, _)
        translator.finish_command
      end

      def to_s
        "#{self.class}"
      end
    end
  end
end