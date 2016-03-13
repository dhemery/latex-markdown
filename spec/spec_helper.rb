require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class FakeTranslator

  def execute_command(command_name)
  end

  def pop
  end

  def push
  end

  def push_end_tag(tag_name)
  end

  def read_argument
  end

  def read_command
  end
end