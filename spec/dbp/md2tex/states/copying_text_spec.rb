require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/states/copying_text'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe CopyingText do
    subject { CopyingText.new }
    let(:scanner) { StringScanner.new(input) }
    let(:translator) do
      Object.new.tap do |t|
        [:write, :enter].each { |m| t.define_singleton_method(m) { |_| } }
      end
    end

    describe 'with input that contains *' do
      let(:input) { 'some text and *some emphasized text*' }

      it 'consumes the text preceding the *' do
        subject.enter(translator, scanner)

        _(scanner.rest).must_equal '*some emphasized text*'
      end

      describe 'tells the translator to' do
        let(:translator) { MiniTest::Mock.new }

        after { translator.verify }

        it 'write the text that precedes the * and enter executing_operator state' do
          translator.expect :write, nil, ['some text and ']
          translator.expect :enter, nil, [:executing_operator]

          subject.enter(translator, scanner)
        end
      end
    end
  end
end
