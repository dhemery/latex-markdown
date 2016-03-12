class ReadingCommand
  def initialize(context, pattern, commands)
    @context = context
    @pattern = pattern
    @commands = commands
  end

  def execute(input, output)
    name = input.scan @pattern
    @context.state = @commands.fetch(name) {  |_| CopyingText.new(@context, /.*/) }
  end
end