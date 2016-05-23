require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/operators/wrap'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe Wrap do
    subject { Wrap.new(wrappers) }

    describe 'tells the translator to' do
      let(:wrappers) do
        [
            {
                name: 'foo',
                open: "\\begin{%s}",
                close: "\\end{%s}"
            }
        ]
      end

      let(:captured) { 'foo' }

      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'write the open text, push the close text, and enter copy_text state' do
        translator.expect :write, nil, ['\begin{foo}']
        translator.expect :push, nil, ['\end{foo}']
        translator.expect :enter, nil, [:copy_text]

        subject.execute(translator, captured)
      end
    end
  end
end
