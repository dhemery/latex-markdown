module TeX2md
  class CopyText
    attr_reader :pattern

    def initialize(pattern)
      @pattern = pattern
    end

    def execute(translator, reader, writer)
      text = reader.scan(@pattern)

      writer.write(text)
      
      translator.read_command
    end

    def to_s
      "#{self.class}#{@pattern.source}"
    end
  end
end