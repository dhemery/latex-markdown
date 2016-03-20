class Translator
  TEXT_PATTERN = /[^\\]*/
  ARGUMENT_PATTERN = /[^\\}]*/
  COMMAND_PATTERN = /[\\}]/

  attr_reader :stack

  def initialize(input, output, commands)
    @input = StringScanner.new input
    @output = output
    @commands = commands.reduce({}){|h,c| h[c.name]= c; h}
    @stack = []
  end

  def translate
    copy_text
    @stack.last.tap{|c| puts "execute: #{c}"}.execute(self, @input, @output) until @stack.empty?
  end

  def copy_text
    push CopyText.new(TEXT_PATTERN)
  end

  def copy_argument
    push CopyText.new(ARGUMENT_PATTERN)
  end

  def execute_command(name)
    command = @commands.fetch(name){|c| raise "No such command #{c || 'nil'} in #{@commands}"}
    push command
  end

  def finish_current_command
    pop
  end

  def read_command
    push ReadCommand.new(COMMAND_PATTERN)
  end

  private

  def push(command)
    @stack.push(command)
  end

  def pop
    @stack.pop
  end
end
