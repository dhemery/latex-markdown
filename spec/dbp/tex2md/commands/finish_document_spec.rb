require_relative '../../../spec_helper'
require 'dbp/tex_to_markdown/finish_document'


module DBP::TexToMarkdown
  describe FinishDocument do
    subject { FinishDocument.new }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.finish_document;
        end
      end
    end
    let(:input) { 'not to be consumed' }
    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }


    it 'identifies itself as nil' do
      _(subject.name).must_be_nil
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

      it 'finish the document' do
        translator.expect :finish_document, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end
