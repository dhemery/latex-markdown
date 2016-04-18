require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/write_page_metadata'

require 'strscan'

module DBP::BookCompiler::TexToMarkdown
  describe WritePageMetadata do
    subject { WritePageMetadata.new(macro) }
    let(:translator) do
      Object.new.tap do |allowing|
        [:copy_argument].each { |m| allowing.define_singleton_method(m) {} }
      end
    end
    let(:macro) { 'mypagemacro' }
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }
    let(:input) { '{the page title}' }

    it 'identifies itself by name' do
      _(subject.name).must_equal macro
    end

    it 'consumes the left brace' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal 'the page title}'
    end

    it 'writes its name as a YAML style attribute' do
      subject.execute(translator, reader, writer)

      _(writer.string.each_line.map(&:chomp)).must_include "style: #{macro}"
    end

    it 'writes the key for a title YAML attribute' do
      subject.execute(translator, reader, writer)

      _(writer.string.lines.last).must_equal 'title: '
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