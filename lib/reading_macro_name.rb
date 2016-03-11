class ReadingMacroName
  def initialize(context)
    @context = context
  end

  def execute(input, output)
    macro_name = input.scan(/[[:alpha:]]*/)
    @context.state = ExecutingMacro.new(macro_name)
  end
end