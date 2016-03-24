require_relative 'command.rb'

module TeX2md
  class CopyText
    include Command

    def initialize(pattern)
      @pattern = pattern
      @continue = true
    end

    def write(writer, text)
      writer.write(text)
    end

    def transition(translator, _)
      translator.read_command
    end

    def ==(other)
      self.class == other.class && self.pattern == other.pattern
    end

    def hash
      [self.class, @pattern].hash
    end

    def to_s
      "#{self.class}#{@pattern.source}"
    end
  end
end