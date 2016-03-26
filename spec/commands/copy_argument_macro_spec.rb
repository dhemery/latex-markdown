require_relative '../spec_helper'
require 'tex2md/commands/copy_argument_macro'

require 'strscan'

describe TeX2md::CopyArgumentMacro do
  subject { TeX2md::CopyArgumentMacro.new(macro_name) }
  let(:macro_name) { 'mymacro' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.copy_argument ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }
  let(:input) { '{--- some text ---}' }

  it 'identifies itself by name' do
    _(subject.name).must_equal macro_name
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal '--- some text ---}'
  end

  describe 'tells the translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'copy the argument' do
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
