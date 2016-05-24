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

    # describe 'extracts' do
    #   let(:input) { '<!-- \somecommand{some argument} -->' }
    #
    #   it 'comment content' do
    #     subject.translate
    #
    #     _(writer.string).must_equal '\somecommand{some argument}'
    #   end
    # end

    # describe 'converts' do
    #   describe 'span.class' do
    #     let(:input) { %q{<span class="foo">span content</span>} }
    #
    #     it 'to \class command with span content as its argument' do
    #       subject.translate
    #
    #       _(writer.string).must_equal '\foo{span content}'
    #     end
    #   end
    # end
  end
end
