require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/operators/write'

module DBP::BookCompiler::MarkdownToTex
  describe Write do
    subject { Write.new }

    describe 'tells the translator to' do
      let(:captured) { 'foo' }

      let(:translator) { MiniTest::Mock.new }

      after { translator.verify }

      it 'write the captured text and enter copy_text state' do
        translator.expect :write, nil, [captured]
        translator.expect :enter, nil, [:copy_text]

        subject.execute(translator, captured)
      end
    end
  end
end
