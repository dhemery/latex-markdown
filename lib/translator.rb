class Translator
  TEXT_COMMAND = '\\'
  ARGUMENT_COMMAND = TEXT_COMMAND + '}'

  attr_reader :current_command

  def copy_text
    @current_command = CopyText.new(self, nil, nil, TEXT_COMMAND)
  end

  def copy_argument
    @current_command = CopyText.new(self, nil, nil, ARGUMENT_COMMAND)
  end

  def read_command(pattern)
    @current_command = ReadCommand.new(self, nil, pattern, nil)
  end
end