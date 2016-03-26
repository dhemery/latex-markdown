module Command
  attr_reader :name, :pattern, :continue
  alias :eql? :==

  def execute(translator, reader, writer)
    captured = read(reader)
    write(writer, captured)
    finish(translator)
    transition(translator, captured)
  end

  def read(reader)
    match = reader.scan(pattern || //)
    reader[1] || match
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
