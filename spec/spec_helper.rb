require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class FakeTranslator

  def copy_argument
  end

  def execute_command(command_name)
  end

  def finish_current_command
  end

  def write_text(text)
  end

  def read_command
  end
end
