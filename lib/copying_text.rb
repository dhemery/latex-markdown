class CopyingText
  def initialize(context, pattern)
    @context = context
    @pattern = pattern
  end

  def execute(input, output)
    output.write input.scan(@pattern)
    @context.state = ReadingCommand.new(@context, /[\\]/, {})
  end
end
