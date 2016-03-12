$LOAD_PATH.unshift '../lib'

require 'copying_text'

require_relative '../spec_helper'

require 'strscan'
require 'reading_command'
require 'ostruct'

describe CopyingText do
  let(:context) { OpenStruct.new }
  let(:output) { StringIO.new }

  before { copying_text.execute(input, output) }

  describe 'when input has no match for the stop pattern' do
    let(:copying_text) { CopyingText.new(context, /[[:punct:]]/) }
    let(:input) { StringScanner.new 'A bunch of text with no punctuation' }

    it 'copies all text' do
      output.string.must_equal input.string
    end

    it 'consumes all input' do
      input.must_be :eos?
    end
  end

  describe 'when input has a match for the stop pattern' do
    let(:copying_text) { CopyingText.new(context, /[[:punct:]]/) }

    let(:input) { StringScanner.new 'stuff1234 ,.!:' }

    it 'copies the text that precedes the stop pattern' do
      output.string.must_equal 'stuff1234 '
    end

    it 'stops scanning at the stop pattern' do
      input.rest.must_equal '.!:'
    end

    it 'enters reading command state' do
      context.state.must_be_instance_of ReadingCommand
    end
  end
end
