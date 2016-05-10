require_relative 'comment'
require_relative 'copy_text'
require_relative 'finish_document'
require_relative 'read_tag'
require_relative 'open_span'
require_relative 'write_text'

module DBP::BookCompiler::MarkdownToTex
  class Translator
    COPY_OUTER_TEXT = CopyText.new
    READ_TAG= ReadTag.new
    COMMANDS = [
        Comment.new,
        FinishDocument.new,
        OpenSpan.new,
        WriteText.new('</span>', '}')
    ]

    def initialize(stack = [])
      @commands = {}.tap { |h| COMMANDS.each { |c| h[c.name] = c } }
      @stack = stack
    end

    def translate(reader, writer)
      copy_outer_text
      @stack.pop.execute(self, reader, writer) until @stack.empty?
    end

    def copy_outer_text
      @stack.push(COPY_OUTER_TEXT)
    end

    def execute_tag(tag)
      @stack.push(command(tag))
    end

    def finish_document
      @stack.clear
    end

    def read_tag
      @stack.push(READ_TAG)
    end

    def resume(command)
      @stack.push(command)
    end

    private

    def command(name)
      @commands.fetch(name) { |_| raise "Unknown command: '#{name}'" }
    end
  end
end