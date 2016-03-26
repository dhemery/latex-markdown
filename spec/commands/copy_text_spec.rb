require_relative '../spec_helper'
require 'tex2md/commands/copy_text'

require 'strscan'

describe TeX2md::CopyText do
  subject { TeX2md::CopyText.new(pattern) }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.read_command ; end
      def allowing.resume(_) ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  describe 'when input begins with a match for the copy pattern' do
    let(:pattern) { /[[:alnum:]]*/ }
    let(:input) { 'stuff1234,.!:' }

    it 'consumes the matching text' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal ',.!:'
    end

    it 'writes the matching text' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_equal 'stuff1234'
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command then resume copying text' do
        translator.expect :read_command, nil
        translator.expect :resume, nil, [subject]

        subject.execute(translator, reader, writer)
      end
    end
  end

  describe 'when input begins with a mismatch for the copy pattern' do
    let(:pattern) { /[[:punct:]]/ }
    let(:input) { 'A bunch of text with no punctuation' }


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

      it 'read a command then resume copying text' do
        translator.expect :read_command, nil
        translator.expect :resume, nil, [subject]

        subject.execute(translator, reader, writer)
      end
    end
  end
end
