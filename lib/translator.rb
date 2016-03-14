class Translator
  TEXT_COMMAND_PATTERN = /[^\\]*/
  COMMAND_PATTERN = /[^\\}]*/

  attr_reader :stack

  def initialize(input, output)
    @input = StringScanner.new input
    @output = output
    @stack = []
  end

  def translate
    copy_text
    @stack.last.execute
  end

  def copy_text
    push CopyText.new(self, @input, @output, TEXT_COMMAND_PATTERN)
  end

  def copy_argument
    push CopyText.new(self, @input, @output, COMMAND_PATTERN)
  end

  def read_command
    push ReadCommand.new(self, @input, COMMAND_PATTERN)
  end

  private

  def push(command)
    @stack.push(command)
  end

  def pop
    @stack.pop
  end
end
