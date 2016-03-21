$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator, 'given LaTeX input' do
  let(:output) { StringIO.new }

  it 'translates plain text' do
    input = 'Some text with no commands.'
    translator = Translator.new(input, output, [ReadMacro.new, Done.new])

    translator.translate

    output.string.must_equal input
  end

  it 'translates text with a no-arg macro' do
    class NoArgMacro
      def name
        'noargmacro'
      end
      def execute(translator, _, output)
        output.write 'no arg macro'
        translator.finish_command
      end
    end
    input = 'Some text \noargmacro'
    translator = Translator.new(input, output, [ReadMacro.new, Done.new, NoArgMacro.new])

    translator.translate

    output.string.must_equal 'Some text no arg macro'
  end

end
