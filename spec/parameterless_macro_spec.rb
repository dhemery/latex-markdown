require_relative 'spec_helper'

require 'translator'

describe 'parameterless macro' do
  let(:translator) { Translator.new(macros) }
  let(:macros) { {} }

  it 'translates known parameterless macros' do
    macros['foo'] = '<foo/>'

    translator.translate('\foo').must_equal macros['foo']
  end
end
