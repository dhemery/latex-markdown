class Translator
  TEXT_COMMAND_PATTERN = '\\'
  COMMAND_PATTERN = TEXT_COMMAND_PATTERN + '}'

  attr_reader :stack

  def initialize
    @stack = []
  end

  def copy_text
    @stack.push CopyText.new(self, nil, nil, TEXT_COMMAND_PATTERN)
  end

  def copy_argument
    @stack.push CopyText.new(self, nil, nil, COMMAND_PATTERN)
  end

  def read_command
    @stack.push ReadCommand.new(self, nil, COMMAND_PATTERN)
  end
end
