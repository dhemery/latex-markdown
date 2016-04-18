require_relative 'command.rb'

module DBP::BookCompiler::TexToMarkdown
  class WritePageMetadata
    include Command

    def initialize(name)
      @name = name
      @pattern = /{/
    end

    def write(writer, _)
      writer.puts("style: #{name}")
      writer.write('title: ')
    end

    def transition(translator, _)
      translator.copy_argument
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end