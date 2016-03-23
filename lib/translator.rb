require 'ignored'
require 'skip_text'

class Translator
  attr_reader :stack

  ARGUMENT_PATTERN = /[^\\}]*/
  COMMAND_PATTERN = /[\\}]/
  MACRO_PATTERN = /[[:alpha:]]+/
  TEXT_PATTERN = /[^\\]*/

  IGNORED_COMMANDS = %w(longpar longpage shortpage shortpar).map{ |w| Ignored.new w }
  IGNORED_MACROS = %w(longpages shortpages).map{ |w| IgnoredMacro.new w}
  SPAN_MACROS = %w(abbr emph leadin unbreakable).map { |m| Tag.new('span', m) }

  STANDARD_COMMANDS = [
      EndDocument.new,
      EndArgument.new,
      Escape.new,
      Tag.new('h1', 'story'),
      Tag.new('h2', 'chapter'),
      Tag.new('h2', 'introduction'),
      Tag.new('h3', 'note'),
  ] + IGNORED_COMMANDS + IGNORED_MACROS + SPAN_MACROS

  def initialize(commands = STANDARD_COMMANDS)
    @commands = commands.reduce({}){|h,c| h[c.name]= c; h}
    @stack = []
  end

  def translate(reader, writer)
    copy_text
    @stack.last.execute(self, reader, writer) until @stack.empty?
  end

  def copy_text(pattern = TEXT_PATTERN)
    push CopyText.new(pattern)
  end

  def copy_argument
    copy_text(ARGUMENT_PATTERN)
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

  def read_macro
    read_command(MACRO_PATTERN)
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
