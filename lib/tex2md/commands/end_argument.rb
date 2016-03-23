class EndArgument
  attr_reader :name
  def initialize
    @name = '}'
  end

  def execute(translator, _, _)
    translator.finish_command # finish this command
    translator.finish_command # finish the macro that had the argument
  end

  def to_s
    "#{self.class}"
  end
end
