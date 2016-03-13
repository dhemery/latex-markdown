class WriteTag
  def initialize(translator, output, tag_name, tag_class)
    @translator = translator
    @output = output
    @tag_name = tag_name
    @tag_class = tag_class
  end

  def execute
    @output.write "<#{@tag_name} class='#{@tag_class}'>"
    @translator.finish_current_command
    @translator.write_text "</#{@tag_name}>"
    @translator.copy_argument
  end
end
