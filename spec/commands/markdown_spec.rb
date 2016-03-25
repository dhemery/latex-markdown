require_relative '../spec_helper'
require 'tex2md/commands/markdown'

require 'strscan'

describe TeX2md::Markdown do
  subject { TeX2md::Markdown.new }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.copy_argument ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }
  let(:input) { '{--- some markdown text ---}' }

  it 'identifies itself as markdown' do
    _(subject.name).must_equal 'markdown'
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal '--- some markdown text ---}'
  end

  describe 'tells the translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the command and copy the argument' do
      translator.expect :finish_command, nil
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
