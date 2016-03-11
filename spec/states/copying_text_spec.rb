require_relative '../spec_helper'

require 'strscan'
require 'copying_text'
require 'reading_command'
require 'ostruct'

describe CopyingText do
  let(:context) { OpenStruct.new }
  let(:output) { StringIO.new }
  let(:copying_text) { CopyingText.new(context) }

  before { copying_text.execute(input, output) }

  describe 'when input has no backslash' do
    let(:input) { StringScanner.new 'A bunch of text with no backslash' }

    it 'copies all text' do
      output.string.must_equal input.string
    end

    it 'consumes all input' do
      input.must_be :eos?
    end
  end

  describe 'when input has a backslash' do
    let(:input) { StringScanner.new 'text text text \macro' }

    it 'copies the text that precedes the backslash' do
      output.string.must_equal 'text text text '
    end

    it 'stops scanning at the backslash' do
      input.rest.must_equal '\macro'
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end

  describe 'when input has a right brace' do
    let(:input) { StringScanner.new 'text text text} more text' }

    it 'copies the text that precedes the right brace' do
      output.string.must_equal 'text text text'
    end

    it 'stops scanning at the right brace' do
      input.rest.must_equal '} more text'
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end
end
