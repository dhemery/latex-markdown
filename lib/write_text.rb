class WriteText
  attr_reader :text

  def initialize(text)
    @text = text
  end

  def execute(translator, _, output)
    output.write @text
    translator.finish_command
  end

  def to_s
    %Q{#{self.class} "#{@text}"}
  end
end