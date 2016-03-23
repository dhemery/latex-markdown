class ElementMacro
  attr_reader :name

  def initialize(name, element)
    @name = name
    @element = element
  end

  def execute(translator, reader, writer)
    reader.scan(/{/)
    writer.write "<#{@element} class='#{@name}'>"

    translator.finish_command
    translator.write_text("</#{@element}>")
    translator.copy_argument
  end

  def to_s
    "#{self.class} #{@element}.#{@name}"
  end
end
