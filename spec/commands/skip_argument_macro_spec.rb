require_relative '../spec_helper'
require 'tex2md/commands/skip_argument_macro'

describe TeX2md::SkipArgumentMacro do
  subject { TeX2md::SkipArgumentMacro.new(macro) }
  let(:macro) { 'myskipargumentmacro' }
  let(:input) { '{argument text}additional text' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.skip_argument ; end
    end
  end
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    _(subject.name).must_equal macro
  end

  it 'consumes the argument' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal 'additional text'
  end

  it 'writes nothing' do
    subject.execute(translator, reader, writer)

    _(writer.string).must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and skip the argument' do
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
