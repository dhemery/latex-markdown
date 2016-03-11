require_relative '../spec_helper'

require 'ostruct'
require 'reading_command'
require 'reading_macro'
require 'strscan'

describe ReadingCommand do
  let(:previous_output) { 'previous output' }
  let(:context) { OpenStruct.new }
  let(:output) { StringIO.new previous_output }
  let(:reading_command) { ReadingCommand.new(context) }

  before { reading_command.execute(input, output) }

  describe 'when next input character is backslash' do
    let(:input) { StringScanner.new '\macroname{macro argument}' }

    it 'consumes the backslash' do
      input.rest.must_equal 'macroname{macro argument}'
    end

    it 'leaves the output unchanged' do
      output.string.must_equal previous_output
    end

    it 'enters reading macro state' do
      context.state.must_be_instance_of ReadingMacro
    end
  end
end
