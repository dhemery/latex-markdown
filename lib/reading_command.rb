class ReadingCommand
  def initialize(context)
    @context = context
  end

  def execute(input, output)
    case input.getch
      when '\\'
        @context.state = ReadingMacroName.new
      when '}'
        @context.state = ConsumingArgument.new
    end
  end
end