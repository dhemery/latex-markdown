require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/finish_argument'


module DBP::BookCompiler::TexToMarkdown
  describe FinishArgument do
    subject { FinishArgument.new }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.finish_command;
        end
      end
    end
    let(:input) { 'not to be consumed' }
    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }

    it 'identifies itself as }' do
      _(subject.name).must_equal '}'
    end

    it 'consumes no input' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal input
    end

    it 'writes no output' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_be_empty
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'finish the command that the macro interrupted' do
        translator.expect :finish_command, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end
