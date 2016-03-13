require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

class FakeContext

  def execute_command(name)
  end

  def pop
  end

  def push
  end

  def read_command
  end
end