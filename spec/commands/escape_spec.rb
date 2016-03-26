require_relative '../spec_helper'
require 'tex2md/commands/escape'


require 'strscan'

describe TeX2md::Escape do
  subject { TeX2md::Escape.new }

  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.execute_command(_) ; end
    end
  end
  let(:macro) { 'mymacro' }
  let(:input) { "#{macro}-not to be consumed" }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself as \\' do
    _(subject.name).must_equal '\\'
  end

  it 'reads the macro name' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal '-not to be consumed'
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    _(writer.string).must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'execute the named macro' do
      translator.expect :execute_command, nil, [macro]

      subject.execute(translator, reader, writer)
    end
  end
end
