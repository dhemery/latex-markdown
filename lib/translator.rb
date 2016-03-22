require 'do_nothing'
require 'skip_text'

class Translator
  TEXT_PATTERN = /[^\\]*/
  ARGUMENT_PATTERN = /[^\\}]*/
  COMMAND_PATTERN = /[\\}]/

  attr_reader :stack

  STANDARD_COMMANDS = [
      Done.new,
      EndArgument.new,
      ReadMacro.new,
  ].concat %w(longpar longpage shortpage shortpar).map{ |w| DoNothing.new w }
    .concat %w(longpages).map{ |w| SkipArgument.new w}

  def initialize(input, output, commands = STANDARD_COMMANDS)
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

  def finish_command
    pop
  end

  def finish_document
    @stack.clear
  end

  def skip_argument
    push SkipText.new(ARGUMENT_PATTERN)
  end

  def read_command(pattern = COMMAND_PATTERN)
    push ReadCommand.new(pattern)
  end

  private

  def push(command)
    @stack.push(command)
  end

  def pop
    @stack.pop
  end
end
