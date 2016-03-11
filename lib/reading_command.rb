class ReadingCommand
  def initialize(context)
    @context = context
  end

  def execute(input, output)
    case input.getch
      when '\\'
        @context.state = ReadingMacroName.new(@context)
      when '}'
        @context.state = ConsumingArgument.new
    end
  end
end