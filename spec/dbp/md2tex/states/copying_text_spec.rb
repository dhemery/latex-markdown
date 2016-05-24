require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/states/copying_text'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe CopyingText do
    subject { CopyingText.new }
    let(:scanner) { StringScanner.new(input) }
    let(:translator) do
      Object.new.tap do |t|
        [:write, :enter].each { |m| t.define_singleton_method(m) { |_|} }
      end
    end

    %w{< * _}.each do |operator_char|
      describe "with input that contains #{operator_char}" do
        let(:pre_operator) { 'text before the operator'}
        let(:post_operator) { 'text after the operator'}
        let(:input) { "#{pre_operator}#{operator_char}#{post_operator}" }

        it "consumes the text before #{operator_char}" do
          subject.enter(translator, scanner)

          _(scanner.rest).must_equal "#{operator_char}#{post_operator}"
        end

        describe 'tells the translator to' do
          let(:translator) { MiniTest::Mock.new }

          after { translator.verify }

          it "write the text that precedes the #{operator_char} and enter executing_operator state" do
            translator.expect :write, nil, [pre_operator]
            translator.expect :enter, nil, [:executing_operator]

            subject.enter(translator, scanner)
          end
        end
      end
    end
  end
end
