require_relative 'command.rb'

module DBP
  module TexToMarkdown
    class CopyText
      include Command

      def initialize(pattern)
        @pattern = pattern
      end

      def write(writer, captured)
        writer.write(captured)
      end

      def transition(translator, _)
        translator.resume(self)
        translator.execute_operator
      end

      def to_s
        "#{self.class}(#{@pattern.source})"
      end
    end
  end
end
