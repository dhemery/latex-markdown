require 'executing_command'

class ReadingCommand
  READ_MACRO = '\\'
  CONSUME_ARGUMENT = '}'

  def initialize(context)
    @context = context
  end

  def execute(input, output)
    @context.state = ExecutingCommand.new(@context, input.getch)
  end
end