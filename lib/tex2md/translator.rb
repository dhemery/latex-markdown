require 'tex2md/commands/begin_environment_macro'
require 'tex2md/commands/copy_argument_macro'
require 'tex2md/commands/copy_text'
require 'tex2md/commands/end_environment_macro'
require 'tex2md/commands/end_argument'
require 'tex2md/commands/end_document'
require 'tex2md/commands/environment'
require 'tex2md/commands/escape'
require 'tex2md/commands/page_macro'
require 'tex2md/commands/read_command'
require 'tex2md/commands/skip_argument_macro'
require 'tex2md/commands/span_macro'
require 'tex2md/commands/skip_text'
require 'tex2md/commands/write_text_macro'

module TeX2md
  class Translator
    ARGUMENT_PATTERN = /[^~\\}]*/
    COMMAND_PATTERN = /[~\\}]/
    MACRO_PATTERN = /[[:alpha:]]+/
    TEXT_PATTERN = /[^~\\]*/

    COPIES = %w(markdown).map { |name| CopyArgumentMacro.new(name) }
    ENVIRONMENTS = %w(dedication quote signature).map { |name| Environment.new(name) }
    NULLS = %w(longpar longpage shortpage shortpar).map{ |name| NullMacro.new(name) }
    REPLACEMENTS = [
        WriteTextMacro.new('~', ' '),
        WriteTextMacro.new('break', '<br />'),
    ]
    SKIPS = %w(longpages shortpages).map{ |name| SkipArgumentMacro.new(name) }
    SPANS = %w(abbr emph leadin unbreakable).map { |style| SpanMacro.new(style) }
    PAGES = %w(chapter introduction note story).map { |style| PageMacro.new(style) }

    STANDARD_COMMANDS = [
        EndDocument.new,
        EndArgument.new,
        Escape.new,
        BeginEnvironmentMacro.new,
        EndEnvironmentMacro.new,
    ] + COPIES + ENVIRONMENTS + NULLS + REPLACEMENTS + SKIPS + SPANS + PAGES

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
      @stack.push(WriteTextMacro.new(nil, text))
    end

    private

    def command(name)
      @commands.fetch(name) do |c|
        command_names = @commands.keys.map { |k| "#{k || 'nil'}" }.sort
        raise "No such command #{c || 'nil'} in [#{command_names.join(', ')}]"
      end
    end
  end
end
