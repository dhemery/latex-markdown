require_relative '../spec_helper'
require 'tex2md/commands/write_text'

describe TeX2md::WriteText do
  subject { TeX2md::WriteText.new(macro, text) }
  let(:macro) { 'mywritetextmacro' }
  let(:text) { 'some text to write' }
  let(:input) { 'not to be consumed' }
  let(:translator) do
    Object.new.tap do |allowing|
    end
  end

  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    _(subject.name).must_equal macro
  end

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal input
  end

  it 'writes the given text' do
    subject.execute(translator, reader, writer)

    _(writer.string).must_equal text
  end

  describe 'tells translator' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'nothing' do
      subject.execute(translator, reader, writer)
    end
  end
end
