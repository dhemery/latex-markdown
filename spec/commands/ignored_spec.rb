require_relative '../spec_helper'
require 'tex2md/commands/ignored_macro'

describe TeX2md::IgnoredMacro do
  subject { TeX2md::IgnoredMacro.new command_name }
  let(:command_name) { 'command' }
  let(:input) { 'not to be consumed' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
    end
  end
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    subject.name.must_equal command_name
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

    it 'finish the current command' do
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
