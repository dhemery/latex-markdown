class ReadingCommand
  def initialize(context, input, pattern, commands)
    @context = context
    @pattern = pattern
    @commands = commands
    @input = input
  end

  def execute
    name = @input.scan @pattern
    if @commands.has_key? name
      @context.execute_command @commands[name]
    else
      @context.pop
    end
  end
end