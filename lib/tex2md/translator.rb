require 'tex2md/commands/begin_environment'
require 'tex2md/commands/copy_text'
require 'tex2md/commands/element_macro'
require 'tex2md/commands/end_environment'
require 'tex2md/commands/end_argument'
require 'tex2md/commands/end_document'
require 'tex2md/commands/environment'
require 'tex2md/commands/escape'
require 'tex2md/commands/ignored_arg_macro'
require 'tex2md/commands/read_command'
require 'tex2md/commands/skip_text'
require 'tex2md/commands/write_text'

module TeX2md
  class Translator
    ARGUMENT_PATTERN = /[^~\\}]*/
    COMMAND_PATTERN = /[~\\}]/
    MACRO_PATTERN = /[[:alpha:]]+/
    TEXT_PATTERN = /[^~\\]*/

    ENVIRONMENTS = %w(dedication quote signature).map { |name| Environment.new(name) }
    IGNORED_MACROS = %w(longpar longpage shortpage shortpar).map{ |name| WriteText.new(name, '') }
    IGNORED_MACROS_WITH_ARGS = %w(longpages shortpages).map{ |name| IgnoredArgMacro.new(name) }
    SPAN_MACROS = %w(abbr emph leadin unbreakable).map { |name| ElementMacro.new(name, 'span') }
    HEADING_MACROS = [
        ElementMacro.new('story', 'h1'),
        ElementMacro.new('chapter', 'h2'),
        ElementMacro.new('introduction', 'h2'),
        ElementMacro.new('note', 'h3'),
    ]
    REPLACEMENTS = [
        WriteText.new('~', ' '),
    ]

    STANDARD_COMMANDS = [
        EndDocument.new,
        EndArgument.new,
        Escape.new,
        BeginEnvironment.new,
        EndEnvironment.new,
    ] + IGNORED_MACROS + IGNORED_MACROS_WITH_ARGS + SPAN_MACROS + HEADING_MACROS + ENVIRONMENTS + REPLACEMENTS

    def initialize(stack = [])
      @commands = STANDARD_COMMANDS.reduce({}){|h,c| h[c.name]= c; h}
      @stack = stack
    end

    def translate(reader, writer)
      copy_text
      @stack.last.execute(self, reader, writer) until @stack.empty?
    end

    def copy_text(pattern = TEXT_PATTERN)
      @stack.push(CopyText.new(pattern))
    end

    def copy_argument
      copy_text(ARGUMENT_PATTERN)
    end

    def execute_command(name)
      @stack.push(command(name))
    end

    def finish_command
      @stack.pop
    end

    def finish_document
      @stack.clear
    end

    def skip_argument
      @stack.push(SkipText.new(ARGUMENT_PATTERN))
    end

    def read_command(pattern = COMMAND_PATTERN)
      @stack.push(ReadCommand.new(pattern))
    end

    def read_macro
      read_command(MACRO_PATTERN)
    end

    def write_text(text)
      @stack.push(WriteText.new(nil, text))
    end

    private

    def command(name)
      @commands.fetch(name) do |c|
        names = @commands.keys.map { |k| (k || 'nil').to_s }
        raise "No such command #{c || 'nil'} in #{names}"
      end
    end
  end
end
