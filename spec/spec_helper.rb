require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class FakeContext
  def push(command)
  end

  def read_command
  end

  def pop
  end

  def execute_command(name)
  end
end