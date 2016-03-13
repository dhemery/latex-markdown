require 'minitest/autorun'
require 'minitest/reporters'
require 'mocha/mini_test'

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