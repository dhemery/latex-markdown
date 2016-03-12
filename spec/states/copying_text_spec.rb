$LOAD_PATH.unshift '../lib'

require 'copying_text'

require_relative '../spec_helper'

require 'strscan'
require 'reading_command'
require 'ostruct'

describe CopyingText do
  let(:context) { OpenStruct.new }
  let(:copying_text) { CopyingText.new(context, pattern) }
  let(:output) { StringIO.new }
  let(:scanner) { StringScanner.new input }

  before { copying_text.execute(scanner, output) }

  describe 'when input has no match for the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }
    let(:previous_output) { 'previous output' }

    it 'consumes no input' do
      scanner.rest.must_equal input
    end

    it 'leaves the output unchanged' do
      output.string.must_equal previous_output
    end
  end

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'copies the matching text' do
      output.string.must_equal 'stuff1234'
    end

    it 'stops scanning at the end of the matching text' do
      scanner.rest.must_equal ',.!:'
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end

  describe 'when the input entirely matches the copy pattern' do
    let(:input) { 'all of this text is printable' }
    let(:pattern) { /[[:print:]]*/ }

    it 'copies the entire input' do
      output.string.must_equal input
    end

    it 'consumes the entire input' do
      scanner.must_be :eos?
    end
  end
end
