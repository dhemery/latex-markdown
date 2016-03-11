require_relative '../spec_helper'

require 'translator'

describe 'parameterless macro' do
  let(:translator) { Translator.new(macros) }
  let(:macros) { {} }

  it 'translates known macros' do
    macros['foo'] = '<foo/>'

    translator.translate_string('\foo').must_equal macros['foo']
  end
end
