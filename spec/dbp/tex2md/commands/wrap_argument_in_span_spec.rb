require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/wrap_argument_in_span'

require 'strscan'

module DBP::BookCompiler::TexToMarkdown
  describe WrapArgumentInSpan do
    subject { WrapArgumentInSpan.new(macro) }
    let(:macro) { 'myspanmacro' }
    let(:input) { '{argument}' }
    let(:translator) do
      Object.new.tap do |t|
        [:copy_argument_text].each { |m| t.define_singleton_method(m) {} }
        [:write_text].each { |m| t.define_singleton_method(m) {|_|} }
      end
    end
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    it 'identifies itself by its name' do
      _(subject.name).must_equal macro
    end

    it 'consumes the left brace' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal 'argument}'
    end

    it 'writes the open span tag with the macro name as its class' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_equal "<span class='#{macro}'>"
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'copy the argument and write the end span tag' do
        translator.expect :write_text, nil, ['</span>']
        translator.expect :copy_argument_text, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end
