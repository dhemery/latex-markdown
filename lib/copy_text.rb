class CopyText
  attr_reader :pattern

  def initialize(translator, input, output, pattern)
    @translator = translator
    @input = input
    @output = output
    @pattern = pattern
  end

  def execute
    @output.write @input.scan(@pattern)
    if @input.eos?
      @translator.finish_current_command
    else
      @translator.read_command
    end
  end
end
