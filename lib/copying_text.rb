class CopyingText
  def initialize(context, input, output, pattern)
    @context = context
    @pattern = pattern
    @input = input
    @output = output
  end

  def execute
    @output.write @input.scan(@pattern)
    if @input.eos?
      @context.pop
    else
      @context.push self
      @context.read_command
    end
  end
end
