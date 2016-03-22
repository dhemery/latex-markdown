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
    %w(longpage longpar shortpage shortpar).each do |m|
      it "\\#{m}" do
        input = "Some text\\#{m}"
        translator = Translator.new(input, output)

        translator.translate

        output.string.must_equal 'Some text'
      end
    end

    %w(longpages shortpages).each do |m|
      it "\\#{m}{n}" do
        input = "Some text\\#{m}{3}"
        translator = Translator.new(input, output)

        translator.translate

        output.string.must_equal 'Some text'
      end
    end
  end

  describe 'replaces' do
    it '\\emph' do
      skip 'TODO: CopyArgument'
      input = "Some \\emph{emphasized} text"

      translator = Translator.new(input, output)

      translator.translate

      output.string.must_equal %q[Some <span class='emph'>emphasized</span> text]
    end
  end
end
