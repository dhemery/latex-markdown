require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/discard_argument'

module DBP::BookCompiler::TexToMarkdown
  describe DiscardArgument do
    subject { DiscardArgument.new(macro) }
    let(:macro) { 'myskipargumentmacro' }
    let(:input) { '{argument text}additional text' }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.skip_argument;
        end
      end
    end
    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }

    it 'identifies itself by name' do
      _(subject.name).must_equal macro
    end

    it 'consumes the argument' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal 'additional text'
    end

    it 'writes nothing' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_be_empty
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
