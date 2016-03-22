class Escape
  def name
    '\\'
  end

  def execute(translator, _, _)
    translator.finish_command
    translator.read_macro
  end

  def to_s
    "#{self.class}"
  end
end