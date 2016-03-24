module TeX2md
  class WriteText
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def execute(translator, _, writer)
      writer.write(@text)
      translator.finish_command
    end

    def to_s
      %Q{#{self.class} "#{@text}"}
    end
  end
end