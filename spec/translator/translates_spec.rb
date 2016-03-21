$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator, 'translate' do
  let(:output) { StringIO.new }

  it 'copies plain text' do
    input = 'Some text with no commands.'
    translator = Translator.new(input, output)

    translator.translate

    output.string.must_equal input
  end

  describe 'ignores' do
    it '\\shortpar' do
      input = 'Some text\\shortpar'
      translator = Translator.new(input, output)

      translator.translate

      output.string.must_equal 'Some text'
    end

    it '\\longpar' do
      input = 'Some text\\longpar'
      translator = Translator.new(input, output)

      translator.translate

      output.string.must_equal 'Some text'
    end
  end
end
