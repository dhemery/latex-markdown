require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/replace'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe Replace do
    subject { Replace.new(replacements) }

    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    describe 'given an input it knows' do
      let(:input) { 'foo' }
      let(:replacement) { 'bar' }
      let(:replacements) { { input => replacement } }

      it 'writes the replacement text and triggers copy_text state' do
        translator.expect :write, nil, [replacement]
        translator.expect :enter, nil, [:copy_text]

        subject.execute(translator, input)
      end
    end
  end
end
