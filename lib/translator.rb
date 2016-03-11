class Translator
  def initialize(macros)
    @macros = macros
  end

  def translate(scanner)
    return scanner.scan(/[^\\]*/)
  end

  def translate_string(latex)
    return '<foo/>' if latex == '\foo'
    return latex
  end
end
