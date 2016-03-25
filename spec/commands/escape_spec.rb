require_relative '../spec_helper'
require 'tex2md/commands/escape'


require 'strscan'

describe TeX2md::Escape do
  subject { TeX2md::Escape.new }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.read_macro ; end
    end
  end
  let(:input) { 'not to be consumed' }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself as \\' do
    subject.name.must_equal '\\'
  end

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal input
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and read a macro' do
      translator.expect :finish_command, nil
      translator.expect :read_macro, nil

      subject.execute(translator, reader, writer)
    end
  end
end
