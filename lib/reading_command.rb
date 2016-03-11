class ReadingCommand
  READ_MACRO = '\\'
  CONSUME_ARGUMENT = '}'

  def initialize(context)
    @context = context
  end

  def execute(input, output)
    case input.getch
      when READ_MACRO
        @context.state = ReadingMacroName.new(@context)
      when CONSUME_ARGUMENT
        @context.state = ConsumingArgument.new
    end
  end
end