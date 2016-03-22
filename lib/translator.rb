require 'do_nothing'
require 'skip_text'

class Translator
  attr_reader :stack

  TEXT_PATTERN = /[^\\]*/
  ARGUMENT_PATTERN = /[^\\}]*/
  COMMAND_PATTERN = /[\\}]/
  MACRO_PATTERN = /[[:alpha:]]+/

  SPAN_COMMANDS = [
      WriteTag.new('span', 'emph'),
  ]

  STANDARD_COMMANDS = [
      EndDocument.new,
      EndArgument.new,
      Escape.new,
  ]
  STANDARD_COMMANDS.concat %w(longpar longpage shortpage shortpar).map{ |w| DoNothing.new w }
  STANDARD_COMMANDS.concat %w(longpages shortpages).map{ |w| SkipArgument.new w}
  STANDARD_COMMANDS.concat SPAN_COMMANDS

  def initialize(commands = STANDARD_COMMANDS)
    @commands = commands.reduce({}){|h,c| h[c.name]= c; h}
    @stack = []
  end

  def translate(reader, writer)
    copy_text
    @stack.last.tap{|c| puts "execute: #{c}"}.execute(self, reader, writer) until @stack.empty?
  end

  def copy_text
    push CopyText.new(TEXT_PATTERN)
  end

  def copy_argument
    push CopyText.new(ARGUMENT_PATTERN)
  end

  def execute_command(name)
    command = @commands.fetch(name){|c| raise "No such command #{c || 'nil'} in #{@commands}"}
    puts "Found command #{name || 'nil'}"
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

  def read_macro
    push ReadCommand.new(MACRO_PATTERN)
  end

  def write_text(text)
    push WriteText.new(text)
  end

  private

  def push(command)
    @stack.push(command)
  end

  def pop
    @stack.pop
  end
end
