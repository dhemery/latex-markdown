module TeX2md
  class Translator
    attr_reader :stack

    ARGUMENT_PATTERN = /[^\\}]*/
    COMMAND_PATTERN = /[\\}]/
    MACRO_PATTERN = /[[:alpha:]]+/
    TEXT_PATTERN = /[^\\]*/

    IGNORED_MACROS = %w(longpar longpage shortpage shortpar).map{ |name| IgnoredMacro.new(name) }
    IGNORED_MACROS_WITH_ARGS = %w(longpages shortpages).map{ |name| IgnoredArgMacro.new(name) }
    SPAN_MACROS = %w(abbr emph leadin unbreakable).map { |name| ElementMacro.new(name, 'span') }
    HEADING_MACROS = [
        ElementMacro.new('story', 'h1'),
        ElementMacro.new('chapter', 'h2'),
        ElementMacro.new('introduction', 'h2'),
        ElementMacro.new('note', 'h3'),
    ]

    STANDARD_COMMANDS = [
        EndDocument.new,
        EndArgument.new,
        Escape.new,
    ] + IGNORED_MACROS + IGNORED_MACROS_WITH_ARGS + SPAN_MACROS + HEADING_MACROS

    def initialize
      @commands = STANDARD_COMMANDS.reduce({}){|h,c| h[c.name]= c; h}
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
end
