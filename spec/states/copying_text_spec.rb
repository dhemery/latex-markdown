$LOAD_PATH.unshift '../lib'

require 'copying_text'

require_relative '../spec_helper'

require 'strscan'

describe CopyingText do
  subject { CopyingText.new(context, scanner, output, pattern) }
  let(:context) { FakeContext.new }
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

    describe 'tells context to' do
      let(:context) { MiniTest::Mock.new }
      it 'pop once' do
        context.expect :pop, nil
        subject.execute
        context.verify
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

    describe 'tells context to' do
      let(:context) { MiniTest::Mock.new }

      it 'push and read a command' do
        context.expect :push, nil
        context.expect :read_command, nil
        subject.execute
        context.verify
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

    describe 'tells context to' do
      let(:context) { MiniTest::Mock.new }

      it 'push current command and read a command' do
        context.expect :push, nil
        context.expect :read_command, nil
        subject.execute
        context.verify
      end
    end
  end
end
