class ReadingMacroName
  MACRO_NAME_PATTERN = /[[:alpha:]]*/

  def initialize(context)
    @context = context
  end

  def execute(input, output)
    macro_name = input.scan(MACRO_NAME_PATTERN)
    @context.state = ExecutingMacro.new(macro_name)
  end
end