require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/states/executing_operator'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe ExecutingOperator do
    subject { ExecutingOperator.new(operators) }
    let(:translator) { Object.new }
    let(:scanner) { StringScanner.new(input) }
    let(:input) { 'foo1barB' }

    let(:operators) do
      [foo_operator, bar_operator]
    end

    let(:foo_operator) do
      foo = MiniTest::Mock.new
      foo.expect :pattern, 'foo\d', []
      foo.expect :names, %w(foo1 foo2 foo3), []
      foo
    end

    let(:bar_operator) do
      bar = MiniTest::Mock.new
      bar.expect :pattern, 'bar[[:upper:]]', []
      bar.expect :names, %w(barA barB barC), []
      bar
    end

    after do
      operators.each { |o| o.verify }
    end

    it 'invokes the operator that matched the pattern' do
      foo_operator.expect :execute, nil, [translator, 'foo1', scanner]

      subject.enter(translator, scanner)

      _(scanner.rest).must_equal 'barB'
    end
  end
end
