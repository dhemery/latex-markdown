require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/copy_argument'

require 'strscan'

module DBP::TexToMarkdown
  describe CopyArgument do
    subject { CopyArgument.new(macro_name) }
    let(:macro_name) { 'mymacro' }
    let(:translator) do
      Object.new.tap do |allowing|
        [:copy_argument].each { |m| allowing.define_singleton_method(m) {} }
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
end
