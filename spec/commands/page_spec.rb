require_relative '../spec_helper'
require 'tex2md/commands/page'

require 'strscan'

describe TeX2md::Page do
  subject { TeX2md::Page.new(style) }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.copy_argument ; end
      def allowing.finish_command ; end
    end
  end
  let(:style) { 'foo' }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }
  let(:input) { '{the page title}' }

  it 'identifies itself by style' do
    _(subject.name).must_equal style
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal 'the page title}'
  end

  it 'writes its style as a YAML attribute' do
    subject.execute(translator, reader, writer)

    _(writer.string.each_line.map(&:chomp)).must_include "style: #{style}"
  end

  it 'writes the key for a title YAML attribute' do
    subject.execute(translator, reader, writer)

    _(writer.string.lines.last).must_equal 'title: '
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