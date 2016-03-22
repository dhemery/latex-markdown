class CopyArgument
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def execute(translator, reader, _)
    reader.getch
    translator.finish_command
    translator.copy_argument
  end

  def to_s
    "#{self.class}"
  end
end