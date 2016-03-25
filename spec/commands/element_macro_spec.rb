require_relative '../spec_helper'
require 'tex2md/commands/element_macro'

require 'strscan'

describe TeX2md::ElementMacro do
  subject { TeX2md::ElementMacro.new(style, element) }
  let(:style) { 'bar' }
  let(:element) { 'foo' }
  let(:input) { '{argument}' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.copy_argument ; end
      def allowing.finish_command ; end
      def allowing.write_text(_) ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself by its style' do
    subject.name.must_equal style
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'argument}'
  end

  it 'writes the open element.style tag' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal "<#{element} class='#{style}'>"
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command, copy the argument, and write the end tag' do
      translator.expect :finish_command, nil
      translator.expect :write_text, nil, ["</#{element}>"]
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
