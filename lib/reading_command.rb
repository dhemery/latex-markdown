class ReadingCommand
  def initialize(context)
    @context = context
  end

  def execute(input, output)
    input.scan /\\/
    @context.state = ReadingMacro.new
  end
end