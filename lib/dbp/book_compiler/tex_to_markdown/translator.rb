require_relative 'copy_argument'
require_relative 'copy_text'
require_relative 'discard_argument'
require_relative 'do_nothing'
require_relative 'enter_environment'
require_relative 'execute_command'
require_relative 'exit_environment'
require_relative 'finish_argument'
require_relative 'finish_document'
require_relative 'wrap_argument_in_span'
require_relative 'write_page_metadata'
require_relative 'write_text'

module DBP
  module TexToMarkdown
    class Translator
      ARGUMENT = /[^~\\}]*/
      OPERATOR = /[~\\}]/
      MACRO_NAME = /[[:alpha:]]+|[$]/
      TEXT = /[^~\\]*/

      COPY_TEXT = CopyText.new(TEXT)
      COPY_ARGUMENT = CopyText.new(ARGUMENT)
      EXECUTE_OPERATOR = ExecuteCommand.new(OPERATOR)

      COPY_ARGUMENT_COMMANDS = %w(markdown).map { |name| CopyArgument.new(name) }
      DISCARD_ARGUMENT_COMMANDS = %w(longpages shortpages).map{ |name| DiscardArgument.new(name) }
      DO_NOTHING_COMMANDS = %w(longpar longpage shortpage shortpar).map{ |name| DoNothing.new(name) }
      WRAP_IN_SPAN_COMMANDS = %w(abbr emph leadin unbreakable).map { |style| WrapArgumentInSpan.new(style) }
      WRITE_PAGE_METADATA_COMMANDS = %w(chapter introduction note story).map { |style| WritePageMetadata.new(style) }
      WRITE_TEXT_COMMANDS = [
          WriteText.new('~', ' '),
          WriteText.new('break', '<br />'),
          WriteText.new('$', '$')
      ]

      COMMANDS = [
          FinishDocument.new,
          FinishArgument.new,
          EnterEnvironment.new,
          ExitEnvironment.new,
          ExecuteCommand.new(MACRO_NAME),
      ] + COPY_ARGUMENT_COMMANDS + DISCARD_ARGUMENT_COMMANDS + DO_NOTHING_COMMANDS + WRAP_IN_SPAN_COMMANDS + WRITE_PAGE_METADATA_COMMANDS + WRITE_TEXT_COMMANDS

      def initialize(stack = [])
        @commands = {}.tap { |h| COMMANDS.each { |c| h[c.name] = c } }
        @stack = stack
      end

      def translate(reader, writer)
        copy_text
        @stack.pop.execute(self, reader, writer) until @stack.empty?
      end

      def copy_argument
        @stack.push(COPY_ARGUMENT)
      end

      def copy_text
        @stack.push(COPY_TEXT)
      end

      def execute_command(name)
        @stack.push(command(name))
      end

      def execute_operator
        @stack.push(EXECUTE_OPERATOR)
      end

      def finish_command
        @stack.pop
      end

      def finish_document
        @stack.clear
      end

      def resume(command)
        @stack.push(command)
      end

      def write_text(text)
        @stack.push(WriteText.new(text))
      end

      private

      def command(name)
        @commands.fetch(name) { |_| raise "Unknown command: #{name}" }
      end
    end
  end
end