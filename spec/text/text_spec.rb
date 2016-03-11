require_relative '../spec_helper'

require 'translator'

describe 'text' do
  let(:translator) { Translator.new(nil) }

  it 'copies non-macro text' do
    translator.translate_string('foo').must_equal 'foo'
  end
end
