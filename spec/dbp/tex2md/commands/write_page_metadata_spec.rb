require_relative '../../../spec_helper'
require 'dbp/tex2md/write_page_metadata'

require 'strscan'

module DBP::TeX2md
  describe WritePageMetadata do
    subject { WritePageMetadata.new(macro) }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.copy_argument;
        end

        def allowing.write_text(_)
          ;
        end
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

    it 'writes a YAML document marker line' do
      subject.execute(translator, reader, writer)

      _(writer.string.lines.first.chomp).must_equal '---'
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

      it 'copy the argument and write a YAML document marker on a new line' do
        translator.expect :write_text, nil, [['', '---'].join($/)]
        translator.expect :copy_argument, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end