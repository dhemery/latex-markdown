require_relative '../spec_helper'

require 'strscan'
require 'translator'

describe 'states' do
  let(:output) { StringIO.new }
  let(:translator) { Translator.new nil }
  let(:scanner) { StringScanner.new input }
  describe 'copying text' do

    describe 'when input has no backslash' do
      let(:input) { 'A bunch of text with no backslash' }

      it 'copies all text' do
        output = translator.translate(scanner)

        output.must_equal input
        scanner.must_be :eos?
      end
    end

    describe 'when input has a backslash' do
      let(:input) { 'text text text \macro' }

      it 'copies the text that precedes the backslash' do
        output = translator.translate(scanner)

        output.must_equal 'text text text '
      end

      it 'leaves the scanner at the backslash' do
        output = translator.translate(scanner)

        scanner.rest.must_equal '\macro'
      end
    end
  end
end
