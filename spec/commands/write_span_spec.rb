$LOAD_PATH.unshift '../lib'

require 'write_span'

require_relative '../spec_helper'

require 'strscan'

describe WriteSpan do
  subject { WriteSpan.new(translator, output, span_class) }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new }
  let(:span_class) { 'foo' }

  it 'writes an open span tag with the CSS class' do
    subject.execute
    output.string.must_equal "<span class='#{span_class}'>"
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    it 'push the end tag and read the argument' do
      translator.expect :push_end_tag, nil, ['span']
      translator.expect :read_argument, nil
      subject.execute
      translator.verify
    end
  end
end
