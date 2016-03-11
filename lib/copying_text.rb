class CopyingText
  TEXT_PATTERN = /[^\\}]*/

  def initialize(context)
    @context = context
  end

  def execute(input, output)
    output.write input.scan(TEXT_PATTERN)
    @context.state = ReadingCommand.new(@context)
  end
end
