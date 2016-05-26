require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/translator'

module DBP::BookCompiler::MarkdownToTex
  describe Translator, 'tokens' do
    CAPTURED_TEXT = 'some capture'

    describe 'BODY_TEXT' do
      subject { Translator::BODY_TEXT }
      let(:translator) { MiniTest::Mock.new }

      describe :pattern do
        describe 'against a string with no operator characters' do
          let(:scanner) { StringScanner.new(input) }
          let(:input) { 'a string with no operator characters!@#$%&()-+=' }

          it 'matches the entire string' do
            scanner.scan(subject[:pattern])

            _(scanner.matched).must_equal input
          end

          it 'captures the entire match' do
            subject[:pattern] =~ input

            _(scanner[1]).must_equal scanner.matched
          end
        end

        %w{< * _}.each do |c|
          describe "against a string with operator character #{c}" do
            let(:body_text) { 'before the operator character' }
            let(:input) { body_text + c + 'additional text' }
            let(:scanner) { StringScanner.new(input) }

            it 'stops matching at the operator character' do
              scanner.scan(subject[:pattern])

              _(scanner.matched).must_equal body_text
            end

            it 'captures the entire match' do
              scanner.scan(subject[:pattern])

              _(scanner[1]).must_equal scanner.matched
            end
          end
        end

        describe :command do
          it 'writes the capture' do
            translator.expect :write, nil, [CAPTURED_TEXT]

            subject[:command].call(translator, CAPTURED_TEXT)

            translator.verify
          end
        end
      end
    end

    describe 'COMMENT_CONTENT' do
      subject { Translator::COMMENT_CONTENT }

      describe :pattern do
        describe 'against a string with a comment' do
          let(:content) { '                   some comment            ' }
          let(:comment) { '<!--' + content + '-->' }
          let(:input) { comment + 'additional text' }
          let(:scanner) { StringScanner.new(input) }

          it 'matches the comment' do
            scanner.scan(subject[:pattern])

            _(scanner.matched).must_equal comment
          end

          it 'captures the stripped comment content' do
            scanner.scan(subject[:pattern])

            _(scanner[1]).must_equal content.strip
          end
        end

        describe :command do
          let(:translator) { MiniTest::Mock.new }

          it 'writes the capture' do
            translator.expect :write, nil, [CAPTURED_TEXT]

            subject[:command].call(translator, CAPTURED_TEXT)

            translator.verify
          end
        end
      end
    end

    describe 'BR_TAG' do
      subject { Translator::BR_TAG }

      describe :pattern do
        describe 'against a string with a BR tag' do
          let(:tag) { '<br        />' }
          let(:input) { tag + 'additional text' }
          let(:scanner) { StringScanner.new(input) }

          it 'matches the tag' do
            scanner.scan(subject[:pattern])

            _(scanner.matched).must_equal tag
          end
        end

        describe :command do
          let(:translator) { MiniTest::Mock.new }

          it 'writes a \break macro' do
            translator.expect :write, nil, ['\break ']

            subject[:command].call(translator, nil) # ignores the capture

            translator.verify
          end
        end
      end
    end

    describe 'DIV_START_TAG' do
      subject { Translator::DIV_START_TAG }

      describe :pattern do
        describe 'against a div tag with a class attribute' do
          let(:class_attribute_value) { '     monkey     ' }
          let(:tag) { %Q{<div                    class    =        "#{class_attribute_value}"              >} }
          let(:input) { tag + 'additional text' }
          let(:scanner) { StringScanner.new(input) }

          it 'matches the tag' do
            scanner.scan(subject[:pattern])

            _(scanner.matched).must_equal tag
          end

          it 'captures the stripped class attribute value' do
            scanner.scan(subject[:pattern])

            _(scanner[1]).must_equal class_attribute_value.strip
          end
        end
      end

      describe :command do
        let(:translator) { MiniTest::Mock.new }

        it 'enters environment named after the capture' do
          translator.expect :enter_environment, nil, [CAPTURED_TEXT]

          subject[:command].call(translator, CAPTURED_TEXT)

          translator.verify
        end
      end
    end
  end
end
