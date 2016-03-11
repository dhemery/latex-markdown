class CopyingText
  def initialize(context)
    @context = context
  end

  def execute(input, output)
    output.write input.scan(/[^\\}]*/)
    @context.state = ReadingCommand.new
  end
end