require_relative '../spec_helper'
require 'tex2md/commands/environment'

require 'strscan'

describe TeX2md::Environment do
  subject { TeX2md::Environment.new(type) }
  let(:type) { 'foo' }
  let(:input) { '}some text\end{foo}' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.copy_text ; end
      def allowing.finish_command ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself by type' do
    subject.name.must_equal type
  end

  it 'consumes the right brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'some text\end{foo}'
  end

  it 'writes an open div tag with the type as its class ' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal %Q{<div class='#{type}'>}
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and copy text' do
      translator.expect :finish_command, nil
      translator.expect :copy_text, nil

      subject.execute(translator, reader, writer)
    end
  end
end
