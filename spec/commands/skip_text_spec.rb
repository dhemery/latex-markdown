$LOAD_PATH.unshift '../lib'

require 'skip_text'

require_relative '../spec_helper'

require 'strscan'

describe SkipText do
  subject { SkipText.new pattern }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new previous_output }
  let(:scanner) { StringScanner.new input }
  let(:previous_output) { 'previous output' }

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'consumes the matching text' do
      subject.execute translator, scanner, output

      scanner.rest.must_equal ',.!:'
    end

    it 'writes no output' do
      subject.execute translator, scanner, output

      output.string.must_equal previous_output
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute translator, scanner, output
      end
    end
  end

  describe 'when input begins with a mismatch for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }

    it 'writes no output' do
      subject.execute translator, scanner, output

      output.string.must_equal previous_output
    end

    it 'consumes no input' do
      subject.execute translator, scanner, output

      scanner.rest.must_equal input
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command' do
        translator.expect :read_command, nil

        subject.execute translator, scanner, output
      end
    end
  end
end
