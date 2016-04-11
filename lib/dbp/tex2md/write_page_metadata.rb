require_relative 'command.rb'

module DBP
  module TeX2md
    class WritePageMetadata
      include Command
      attr_reader :text

      def initialize(name)
        @name = name
        @pattern = /{/
        @text = "style: #{name}#{$/}title: "
      end

      def write(writer, _)
        writer.puts('---')
        writer.write(text)
      end

      def transition(translator, _)
        translator.write_text(['', '---'].join($/))
        translator.copy_argument
      end

      def to_s
        "#{self.class}(#{name})"
      end
    end
  end
end