require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/translator'

module DBP::BookCompiler::MarkdownToTex
  describe Translator do
    subject { Translator.new(reader, writer) }
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    describe 'copies' do
      let(:input) { %q{A bunch of text that doesn't include any operators} }

      it 'non-operator text' do
        subject.translate

        _(writer.string).must_equal input
      end
    end

    describe 'extracts' do
      let(:input) { '<!-- \somecommand{some argument} -->' }

      it 'comment content' do
        subject.translate

        _(writer.string).must_equal '\somecommand{some argument}'
      end
    end

    describe 'replaces' do
      describe '<br/>' do
        let(:input) { '<br/>' }

        it 'with \break' do
          subject.translate

          _(writer.string).must_equal '\break '
        end
      end
    end

    describe 'raises an error' do
      let(:input) { 'some okay text<WHATISTHIS?' }
      it 'the characters that start with < do not match a token pattern' do
        err = ->{ subject.translate }.must_raise RuntimeError
        err.message.must_match '<WHATISTHIS?'
      end
    end

    # describe 'converts' do
    #   describe 'div.class' do
    #     let(:input) { %q{<div class="foo">div content</div>} }
    #
    #     it 'to a \begin{} macro with the class as its environment name' do
    #       subject.translate
    #
    #       _(writer.string).must_equal '\begin{foo}div content\end{foo}'
    #     end
    #   end
    # end
  end
end
