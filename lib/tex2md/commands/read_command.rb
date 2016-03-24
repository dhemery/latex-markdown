module TeX2md
  class ReadCommand
    attr_reader :pattern

    def initialize(pattern)
      @pattern = pattern
    end

    def execute(translator, reader, _)
      command_name = reader.scan(@pattern)

      translator.finish_command
      translator.execute_command(command_name)
    end

    def to_s
      "#{self.class}#{@pattern.source}"
    end
  end
end