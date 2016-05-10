require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/open_span'


module DBP::BookCompiler::MarkdownToTex
  describe OpenSpan do
    subject { OpenSpan.new }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.finish_document;
        end
      end
    end

    it 'identifies itself as <span' do
      _(subject.name).must_equal '<span'
    end

    describe 'when the span has only a class attribute' do
      let(:input) { %q{   class='foo'>content} }
      let(:reader) { StringScanner.new input }
      let(:writer) { StringIO.new }

      it 'consumes the rest of the open span tag' do
        subject.execute(translator, reader, writer)

        _(reader.rest).must_equal 'content'
      end

      it 'writes the start of a command named after the span class' do
        subject.execute(translator, reader, writer)

        _(writer.string).must_equal '\foo{'
      end

      describe 'tells translator' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'nothing' do
          subject.execute(translator, reader, writer)
        end
      end
    end

    describe 'when the span has additional attributes' do
      let(:input) { %q{   monkey='monkey' class='foo' shines="shines">content} }
      let(:reader) { StringScanner.new input }
      let(:writer) { StringIO.new }

      it 'consumes the rest of the open span tag' do
        subject.execute(translator, reader, writer)

        _(reader.rest).must_equal 'content'
      end

      it 'writes the start of a command named after the span class' do
        subject.execute(translator, reader, writer)

        _(writer.string).must_equal '\foo{'
      end

      describe 'tells translator' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'nothing' do
          subject.execute(translator, reader, writer)
        end
      end
    end
  end
end
