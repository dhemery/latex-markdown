require_relative '../spec_helper'
require 'tex2md/commands/end_argument'


describe EndArgument do
  subject { EndArgument.new }
  let(:translator) { FakeTranslator.new }
  let(:input) { 'not to be consumed' }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself as }' do
    subject.name.must_equal '}'
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

    it 'finish the current command and the previous command' do
      translator.expect :finish_command, nil
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
