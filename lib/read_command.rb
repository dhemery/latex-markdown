class ReadCommand
  attr_reader :pattern

  def initialize(translator, input, pattern, commands)
    @translator = translator
    @input = input
    @pattern = pattern
    @commands = commands
  end

  def execute
    name = @input.scan @pattern
    if @commands.has_key? name
      @translator.execute_command @commands[name]
    else
      @translator.pop
    end
  end
end