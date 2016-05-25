require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/translator'

module DBP::BookCompiler::MarkdownToTex
  describe Translator, 'tokens' do
    describe 'BODY_TEXT' do
      subject { Translator::BODY_TEXT }

      describe :pattern do
        let(:pattern) { subject[:pattern] }

        describe 'against a string with no operator characters' do
          it 'matches the entire string' do
            input = 'a bunch of text'
            pattern =~ input
            _($&).must_equal input
          end

          it 'captures the entire match' do
            input = 'a bunch of text'
            pattern =~ input
            _($1).must_equal input
          end
        end

        %w{< * _}.each do |c|
          describe "against a string with operator character #{c}" do
            it 'stops matching at the operator character' do
              input = "before#{c}after"
              pattern =~ input
              _($&).must_equal 'before'
            end

            it 'captures the entire match' do
              input = "before#{c}after"
              pattern =~ input
              _($1).must_equal 'before'
            end
          end
        end

        describe :command do
          let(:command) { subject[:command] }
          let(:translator) { MiniTest::Mock.new }

          after { translator.verify }

          it 'writes the captured text' do
            capture = 'some capture'

            translator.expect :write, nil, [capture]
            command.call(translator, capture)
          end
        end
      end
    end
  end
end
