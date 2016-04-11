require_relative 'command.rb'

module DBP
  module TeX2md
    class WrapArgumentInSpan
      include Command
      attr_reader :text

      def initialize(name)
        @name = name
        @pattern = /{/
        @text = "<span class='#{name}'>"
      end

      def write(writer, _)
        writer.write(text)
      end

      def transition(translator, _)
        translator.write_text('</span>')
        translator.copy_argument
      end

      def to_s
        "#{self.class}(#{name})"
      end
    end
  end
end