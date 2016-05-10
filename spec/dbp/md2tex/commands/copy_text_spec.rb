require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/copy_text'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe CopyText do
    subject { CopyText.new }
    let(:translator) do
      Object.new.tap do |t|
        [:read_tag].each { |m| t.define_singleton_method(m) {} }
        [:resume].each { |m| t.define_singleton_method(m) { |_|} }
      end
    end
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    %w(<).each do |stop_char|
      describe "stops at #{stop_char}" do
        let(:input) { "before#{stop_char}after" }

        it 'consuming the preceding input' do
          subject.execute(translator, reader, writer)

          _(reader.rest).must_equal "#{stop_char}after"
        end

        it 'writing the preceding input' do
          subject.execute(translator, reader, writer)

          _(writer.string).must_equal 'before'
        end

        describe 'telling the translator to' do
          let(:translator) { MiniTest::Mock.new }
          after { translator.verify }

          it 'read a tag then resume copying text' do
            translator.expect :read_tag, nil
            translator.expect :resume, nil, [subject]

            subject.execute(translator, reader, writer)
          end
        end
      end
    end
  end
end