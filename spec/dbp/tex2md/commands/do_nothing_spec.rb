require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/do_nothing'

module DBP::BookCompiler::TexToMarkdown
  describe DoNothing do
    subject { DoNothing.new(macro) }
    let(:macro) { 'mydonothing' }
    let(:input) { 'not to be consumed' }
    let(:translator) do
      Object.new.tap do |allowing|
      end
    end

    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }

    it 'identifies itself by name' do
      _(subject.name).must_equal macro
    end

    it 'consumes no input' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal input
    end

    it 'writes no output' do
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
