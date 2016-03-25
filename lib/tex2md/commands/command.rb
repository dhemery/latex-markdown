module Command
  attr_reader :name, :pattern, :continue
  alias :eql? :==

  def execute(translator, reader, writer)
    text = read(reader)
    write(writer, text)
    finish(translator)
    transition(translator, text)
  end

  def read(reader)
    reader.scan(pattern) if pattern
  end

  def write(_, _) ; end

  def finish(translator)
    translator.finish_command unless continue
  end

  def transition(_, _) ; end

  def ==(other)
    self.to_s == other.to_s
  end

  def hash
    to_s.hash
  end
end
