require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/operators/pop'

module DBP::BookCompiler::MarkdownToTex
  describe Pop do
    subject { Pop.new }

    describe 'tells the translator to' do
      let(:captured) { 'foo' }

      let(:translator) { MiniTest::Mock.new }

      after { translator.verify }

      it 'pop and enter copy_text state' do
        translator.expect :pop, nil, []
        translator.expect :enter, nil, [:copying_text]

        subject.execute(translator, captured)
      end
    end
  end
end
