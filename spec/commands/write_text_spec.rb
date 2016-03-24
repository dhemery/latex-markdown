require_relative '../spec_helper'
require 'tex2md/commands/write_text'

describe TeX2md::WriteText do
  subject { TeX2md::WriteText.new text }
  let(:text) { 'some text to write' }
  let(:input) { 'not to be consumed' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
    end
  end

  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal input
  end

  it 'writes the given text' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal text
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command' do
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
