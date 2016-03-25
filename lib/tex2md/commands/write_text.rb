require_relative 'command.rb'

module TeX2md
  class WriteText
    include Command

    attr_reader :text

    def initialize(text)
      @text = text
    end

    def write(writer, _)
      writer.write(@text)
    end

    def ==(other)
      self.class == other.class && self.text == other.text
    end

    def hash
      [self.class, @text].hash
    end

    def to_s
      %Q{#{self.class} "#{@text}"}
    end
  end
end