class CopyText
  attr_reader :pattern

  def initialize(pattern)
    @pattern = pattern
  end

  def execute(translator, input, output)
    output.write input.scan(@pattern)
    translator.read_command
  end

  def to_s
    "#{self.class}#{@pattern.source}"
  end
end
