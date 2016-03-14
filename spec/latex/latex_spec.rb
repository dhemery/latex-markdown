$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator do
  let(:output) { StringIO.new }

  it 'translates plain text' do
    input = "Some text with no commands."
    translator = Translator.new(input, output)
    translator.translate
    output.string.must_equal input
  end
end
