class ReadingCommand
  def initialize(context, input, output, pattern, commands)
    @context = context
    @pattern = pattern
    @commands = commands
    @output = output
    @input = input
  end

  def execute
    name = @input.scan @pattern
    @context.state = @commands.fetch(name) {  |_| CopyingText.new(@context, @input, @output, /.*/) }
  end
end