class Tag
  attr_reader :name

  def initialize(tag, type)
    @tag = tag
    @name = type
  end

  def execute(translator, reader, writer)
    reader.scan(/{/)
    writer.write "<#{@tag} class='#{@name}'>"

    translator.finish_command
    translator.write_text("</#{@tag}>")
    translator.copy_argument
  end

  def to_s
    "#{self.class} #{@tag}.#{@name}"
  end
end
