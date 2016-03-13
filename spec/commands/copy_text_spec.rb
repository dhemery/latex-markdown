$LOAD_PATH.unshift '../lib'

require 'copy_text'

require_relative '../spec_helper'

require 'strscan'

describe CopyText do
  subject { CopyText.new(translator, scanner, output, pattern) }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new }
  let(:scanner) { StringScanner.new input }

  describe 'when the input entirely matches the copy pattern' do
    let(:input) { 'all of this text is printable' }
    let(:pattern) { /[[:print:]]*/ }

    it 'writes all input' do
      subject.execute
      output.string.must_equal input
    end

    it 'consumes all input' do
      subject.execute
      scanner.must_be :eos?
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      it 'finish the current command' do
        translator.expect :finish_current_command, nil
        subject.execute
        translator.verify
      end
    end
  end

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'writes the matching text' do
      subject.execute
      output.string.must_equal 'stuff1234'
    end

    it 'consumes the matching text' do
      subject.execute
      scanner.rest.must_equal ',.!:'
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }

      it 'read a command' do
        translator.expect :read_command, nil
        subject.execute
        translator.verify
      end
    end
  end

  describe 'when input contains no match for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }
    let(:previous_output) { 'previous output' }

    it 'writes no output' do
      subject.execute
      output.string.must_equal previous_output
    end

    it 'consumes no input' do
      subject.execute
      scanner.rest.must_equal input
    end

    describe 'tells traslator to' do
      let(:translator) { MiniTest::Mock.new }

      it 'read a command' do
        translator.expect :read_command, nil
        subject.execute
        translator.verify
      end
    end
  end
end
