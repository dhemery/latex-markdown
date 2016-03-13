class Translator
  COMMAND_IN_TEXT = /\\/

  attr_reader :current_command

  def copy_text
    @current_command = CopyText.new(self, nil, nil, COMMAND_IN_TEXT)
  end
end