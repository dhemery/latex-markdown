class WriteTag
  def initialize(tag_name, tag_class)
    @tag_name = tag_name
    @tag_class = tag_class
  end

  def execute(translator, _, output)
    output.write "<#{@tag_name} class='#{@tag_class}'>"
    translator.finish_current_command
    translator.write_text "</#{@tag_name}>"
    translator.copy_argument
  end

  def to_s
    "#{self.class}[#{@tag_name}.#{@tag_class}]"
  end
end
