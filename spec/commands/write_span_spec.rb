$LOAD_PATH.unshift '../lib'

require 'write_span'

require_relative '../spec_helper'

require 'strscan'

describe WriteSpan do
  subject { WriteSpan.new(context, output, span_class) }
  let(:context) { FakeContext.new }
  let(:output) { StringIO.new }
  let(:span_class) { 'foo' }

  it 'writes an open span tag with the CSS class' do
    subject.execute
    output.string.must_equal "<span class='#{span_class}'>"
  end

  describe 'tells context to' do
    let(:context) { MiniTest::Mock.new }
    it 'push the end tag and read the argument' do
      context.expect :push_end_tag, nil, ['span']
      context.expect :read_argument, nil
      subject.execute
      context.verify
    end
  end
end
