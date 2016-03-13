class ReadCommand
  def initialize(context, input, pattern, commands)
    @context = context
    @input = input
    @pattern = pattern
    @commands = commands
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