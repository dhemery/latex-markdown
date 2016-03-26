require_relative 'command.rb'

module TeX2md
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
      translator.read_command
    end

    def to_s
      "#{self.class}(#{@pattern.source})"
    end
  end
end