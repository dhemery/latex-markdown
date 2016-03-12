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

  describe 'when the input entirely matches the copy pattern' do
    let(:input) { 'all of this text is printable' }
    let(:pattern) { /[[:print:]]*/ }

    it 'writes all input' do
      output.string.must_equal input
    end

    it 'consumes all input' do
      scanner.must_be :eos?
    end
  end

  describe 'when input begins with a match for the copy pattern' do
    let(:input) { 'stuff1234,.!:' }
    let(:pattern) { /[[:alnum:]]*/ }

    it 'writes the matching text' do
      output.string.must_equal 'stuff1234'
    end

    it 'consumes only the matching text' do
      scanner.rest.must_equal ',.!:'
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end

  describe 'when the input matches following a mismatch' do
    let(:input) { ',.:punctuation followed by text' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:alnum:]]/ }
    let(:previous_output) { 'previous output' }

    it 'consumes no input' do
      scanner.rest.must_equal input
    end

    it 'writes no output' do
      output.string.must_equal previous_output
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end

  describe 'when input entirely mismatches the copy pattern' do
    let(:input) { 'A bunch of text with no punctuation' }
    let(:output) { StringIO.new previous_output }
    let(:pattern) { /[[:punct:]]/ }
    let(:previous_output) { 'previous output' }

    it 'writes no output' do
      output.string.must_equal previous_output
    end

    it 'consumes no input' do
      scanner.rest.must_equal input
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end
end
