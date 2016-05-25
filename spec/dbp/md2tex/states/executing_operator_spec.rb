require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/states/executing_operator'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe ExecutingOperator do
    subject { ExecutingOperator.new([foo]) }
    let(:translator) do
      Object.new.tap do |t|
        [:transition_to].each { |m| t.define_singleton_method(m) { |_| } }
      end
    end
    let(:scanner) { StringScanner.new(input) }
    let(:input) { 'foo1     rabbit     monkey' }
    let(:command) { MiniTest::Mock.new }
    let(:pattern) { '(foo\d)[[:space:]]*([[:alpha:]]+)[[:space:]]*' }
    let(:foo) do
      {
          names: %w(foo1 foo2 foo3),
          pattern: pattern,
          command: command
      }
    end

    before do
      command.expect :call, nil, [translator, 'foo1', 'rabbit']
    end

    it %q{invokes the operator's command with the argument} do
      subject.enter(translator, scanner)

      command.verify
    end

    it %q{consumes the operator's entire pattern} do
      subject.enter(translator, scanner)

      _(scanner.rest).must_equal 'monkey'
    end

    describe 'tells the translator to' do
      let(:translator) { MiniTest::Mock.new }

      it 'transition to :copying_text' do
        translator.expect :transition_to, nil, [:copying_text]

        subject.enter(translator, scanner)

        translator.verify
      end
    end
  end
end
