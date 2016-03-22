$LOAD_PATH.unshift '../lib'

require 'skip_text'

require_relative '../spec_helper'

require 'strscan'

describe SkipText do
  subject { SkipText.new pattern }
  let(:translator) { FakeTranslator.new }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'consumes the matching text' do
      subject.execute(translator, reader, writer)

      reader.rest.must_equal ',.!:'
    end

    it 'writes no output' do
      subject.execute(translator, reader, writer)

      writer.string.must_be_empty
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute(translator, reader, writer)
      end
    end
  end

  describe 'when input begins with a mismatch for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:writer) { StringIO.new }
    let(:pattern) { /[[:punct:]]/ }

    it 'writes no output' do
      subject.execute(translator, reader, writer)

      writer.string.must_be_empty
    end

    it 'consumes no input' do
      subject.execute(translator, reader, writer)

      reader.rest.must_equal input
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end
