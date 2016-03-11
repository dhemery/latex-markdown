class ExecutingCommand
  attr_reader :name

  def initialize(context, name)
    @context = context
    @name = name
  end

  def execute(input, output)
  end
end