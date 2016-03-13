$LOAD_PATH.unshift '../lib'

require 'copying_text'

require_relative '../spec_helper'

require 'strscan'
require 'reading_command'
require 'ostruct'

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

    it 'pops the context' do
      context.expects(:pop)
      subject.execute
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

    it 'pushes itself' do
      context.expects(:push).with(subject)
      subject.execute
    end

    it 'tells the context to read a command' do
      context.expects(:read_command)
      subject.execute
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

    it 'pushes itself' do
      context.expects(:push).with(subject)
      subject.execute
    end

    it 'tells the context to read a command' do
      context.expects(:read_command)
      subject.execute
    end

  end
end
