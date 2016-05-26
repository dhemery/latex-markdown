require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/translator'

module DBP::BookCompiler::MarkdownToTex
  describe Translator do
    subject { Translator.new(reader, writer) }
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    describe 'wraps' do
      describe 'div.class' do
        let(:content) { 'some content'}
        let(:environment) { 'foo' }
        let(:input) { %Q{<div class="#{environment}">#{content}</div>} }

        it 'in the environment specified by the div class' do
          subject.translate

          _(writer.string).must_equal "\\begin{#{environment}}#{content}\\end{#{environment}}"
        end
      end

      describe 'span.class' do
        let(:content) { 'some content'}
        let(:macro) { 'foo' }
        let(:input) { %Q{<span class="#{macro}">#{content}</span>} }

        it 'in a call to the macro specified by the span class' do
          subject.translate

          _(writer.string).must_equal "\\#{macro}{#{content}}"
        end
      end
    end

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

    describe 'rejects' do
      let(:input) { 'some okay text<WHATISTHIS?' }
      it 'a string starting with < that does not match any other token pattern' do
        err = ->{ subject.translate }.must_raise RuntimeError
        err.message.must_match '<WHATISTHIS?'
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
  end
end
