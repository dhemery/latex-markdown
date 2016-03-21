class ReadMacro
  MACRO_NAME = /[[:alpha:]]+/

  def name
    '\\'
  end

  def execute(translator, _, _)
    translator.finish_command
    translator.read_command MACRO_NAME
  end
end