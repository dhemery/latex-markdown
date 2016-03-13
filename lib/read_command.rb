class ReadCommand
  attr_reader :pattern

  def initialize(translator, input, pattern)
    @translator = translator
    @input = input
    @pattern = pattern
  end

  def execute
    @translator.finish_current_command
    @translator.execute_command @input.scan(@pattern)
  end
end
