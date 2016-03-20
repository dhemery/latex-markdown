class ReadCommand
  attr_reader :pattern

  def initialize(pattern)
    @pattern = pattern
  end

  def execute(translator, input, _)
    translator.finish_current_command
    translator.execute_command input.scan(@pattern)
  end

  def to_s
    "#{self.class}#{@pattern.source}"
  end
end
