$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

class ReadMacro
  attr_reader :name
  def initialize
    @name = '\\'
  end

  def execute(translator, _, _)
    translator.finish_command
  end

  def to_s
    "#{self.class}"
  end
end

describe Translator, 'given LaTeX input' do
  let(:output) { StringIO.new }

  it 'translates plain text' do

    input = 'Some text with no commands.'
    translator = Translator.new(input, output, [ReadMacro.new, Done.new])
    translator.translate
    output.string.must_equal input
  end
end
