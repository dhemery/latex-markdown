require_relative 'command.rb'

module DBP::BookCompiler::TexToMarkdown
  class WriteText
    include Command
    attr_reader :text

    def initialize(name='anonymous', text)
      @name = name
      @text = text
    end

    def write(writer, _)
      writer.write(text)
    end

    def to_s
      "#{self.class}(#{name},#{text})"
    end
  end
end