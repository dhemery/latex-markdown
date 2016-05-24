module DBP::BookCompiler::MarkdownToTex
  class ExecutingOperator

    def initialize(operators)
      @operators_by_name = {}
      operators.each do |operator|
        operator.names.each do |name|
          @operators_by_name[name] = operator
        end
      end
      pattern_string = operators.map(&:pattern).join('|')
      @pattern = Regexp.new(pattern_string)
    end

    def enter(translator, scanner)
      scanner.scan @pattern
      match = scanner[0]
      operator = @operators_by_name[match]
      operator.execute(translator, match, scanner)
    end
  end
end