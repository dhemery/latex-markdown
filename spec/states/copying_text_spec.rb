$LOAD_PATH.unshift '../lib'

require 'copying_text'

require_relative '../spec_helper'

require 'strscan'
require 'reading_command'
require 'ostruct'

describe CopyingText do
  let(:context) { FakeContext.new }
  let(:copying_text) { CopyingText.new(context, scanner, output, pattern) }
  let(:output) { StringIO.new }
  let(:scanner) { StringScanner.new input }

  describe 'when the input entirely matches the copy pattern' do
    let(:input) { 'all of this text is printable' }
    let(:pattern) { /[[:print:]]*/ }

    it 'writes all input' do
      copying_text.execute
      output.string.must_equal input
    end

    it 'consumes all input' do
      copying_text.execute
      scanner.must_be :eos?
    end

    it 'pops the context' do
      context.expects(:pop)
      copying_text.execute
    end
  end

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'writes the matching text' do
      copying_text.execute
      output.string.must_equal 'stuff1234'
    end

    it 'consumes the matching text' do
      copying_text.execute
      scanner.rest.must_equal ',.!:'
    end

    it 'pushes itself' do
      context.expects(:push).with(copying_text)
      copying_text.execute
    end

    it 'tells the context to read a command' do
      context.expects(:read_command)
      copying_text.execute
    end
  end

  describe 'when input contains no match for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }
    let(:previous_output) { 'previous output' }

    it 'writes no output' do
      copying_text.execute
      output.string.must_equal previous_output
    end

    it 'consumes no input' do
      copying_text.execute
      scanner.rest.must_equal input
    end

    it 'pushes itself' do
      context.expects(:push).with(copying_text)
      copying_text.execute
    end

    it 'tells the context to read a command' do
      context.expects(:read_command)
      copying_text.execute
    end

  end
end
