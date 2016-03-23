require_relative '../spec_helper'
require 'tex2md/commands/end_document'


describe EndDocument do
  subject { EndDocument.new }
  let(:translator) { FakeTranslator.new }
  let(:input) { 'not to be consumed' }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }


  it 'identifies itself as nil' do
    subject.name.must_be_nil
  end

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal input
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the command then finish the document' do
      translator.expect :finish_command, nil
      translator.expect :finish_document, nil

      subject.execute(translator, reader, writer)
    end
  end
end
