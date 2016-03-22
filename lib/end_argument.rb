class EndArgument
  attr_reader :name
  def initialize
    @name = '}'
  end

  def execute(translator, _, _)
    translator.finish_command
    translator.finish_command
  end

  def to_s
    "#{self.class}"
  end
end
