class CopyingText
  TEXT_PATTERN = /[^\\}]*/

  def initialize(context, stop_pattern)
    @context = context
    @stop_pattern = stop_pattern
  end

  def execute(input, output)
    if input.scan_until(@stop_pattern)
      output.write input.pre_match
      @context.state = ReadingCommand.new(@context)
    else
      output.write input.scan(/.*/)
      input.terminate
    end
  end
end
