class Translator
  TEXT_COMMAND = '\\'
  ARGUMENT_COMMAND = TEXT_COMMAND + '}'

  attr_reader :stack

  def initialize
    @stack = []
  end

  def copy_text
    @stack.push CopyText.new(self, nil, nil, TEXT_COMMAND)
  end

  def copy_argument
    @stack.push CopyText.new(self, nil, nil, ARGUMENT_COMMAND)
  end

  def read_command(pattern)
    @stack.push ReadCommand.new(self, nil, pattern, nil)
  end
end
