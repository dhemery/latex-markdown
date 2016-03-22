class SkipArgument
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def execute(translator, input, _)
    input.getch
    translator.finish_command
    translator.skip_argument
  end

  def to_s
    "#{self.class}"
  end
end