require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/operators/replace'

module DBP::BookCompiler::MarkdownToTex
  describe Replace do
    subject { Replace.new(replacements) }

    describe 'tells the translator to' do
      let(:replacements) { { captured => replacement } }

      let(:captured) { 'foo' }
      let(:replacement) { 'bar' }
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'write the replacement text and enter copy_text state' do
        translator.expect :write, nil, [replacement]
        translator.expect :enter, nil, [:copy_text]

        subject.execute(translator, captured)
      end
    end
  end
end
