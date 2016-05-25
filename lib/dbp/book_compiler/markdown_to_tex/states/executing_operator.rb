require_relative 'state'

module DBP::BookCompiler::MarkdownToTex
  class ExecutingOperator
    include State

    def initialize(operators)
      @next_state = :copying_text
      @operators_by_name = {}
      operators.each do |operator|
        operator[:names].each do |name|
          @operators_by_name[name] = operator
        end
      end
      pattern_string = operators.map { |o| o[:pattern] }.join('|')
      @pattern = Regexp.new(pattern_string)
    end

    def respond(translator, scanned)
      name = scanned[1]
      arg = scanned[2]
      operator = @operators_by_name[name]
      operator[:command].call(translator, name, arg) unless operator.nil?
    end
  end
end