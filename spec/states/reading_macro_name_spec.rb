require_relative '../spec_helper'

require 'strscan'
require 'reading_macro_name'
require 'executing_macro'
require 'ostruct'

describe ReadingMacroName do
  let(:context) { OpenStruct.new }
  let(:previous_output) { 'previous output' }
  let(:output) { StringIO.new previous_output }
  let(:reading_macro_name) { ReadingMacroName.new(context) }

  before { reading_macro_name.execute(input, output) }

  describe 'reads letters as a macro name' do
    let(:input) { StringScanner.new 'macroname1 2 43 !' }

    it 'enters executing macro state' do
      context.state.must_be_instance_of ExecutingMacro
      context.state.name.must_equal 'macroname'
    end

    it 'leaves the output unchanged' do
      output.string.must_equal previous_output
    end

    it 'stops scanning at first non-letter' do
      input.rest.must_equal '1 2 43 !'
    end
  end
end
