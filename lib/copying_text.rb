class CopyingText
  def initialize(context, input, output, pattern)
    @context = context
    @pattern = pattern
    @input = input
    @output = output
  end

  def execute
    @output.write @input.scan(@pattern)
    @context.state = ReadingCommand.new(@context, @input, @output, /[\\]/, {})
  end
end
