require_relative '../spec_helper'
require 'tex2md/commands/do_nothing'

describe TeX2md::DoNothing do
  subject { TeX2md::DoNothing.new(macro) }
  let(:macro) { 'mydonothing' }
  let(:input) { 'not to be consumed' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
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

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    _(writer.string).must_be_empty
  end

  describe 'tells translator' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'nothing' do
      subject.execute(translator, reader, writer)
    end
  end
end
