require_relative '../../../spec_helper'
require 'dbp/tex_to_markdown/copy_text'

require 'strscan'

module DBP::TexToMarkdown
  describe CopyText do
    subject { CopyText.new(pattern) }
    let(:pattern) { /[[:alnum:]]*/ }

    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.execute_operator;
        end

        def allowing.resume(_)
          ;
        end
      end
    end
    let(:input) { 'stuff1234,.!:' }
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    it 'consumes the matching text' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal ',.!:'
    end

    it 'writes the matching text' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_equal 'stuff1234'
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'read a command then resume copying text' do
        translator.expect :execute_operator, nil
        translator.expect :resume, nil, [subject]

        subject.execute(translator, reader, writer)
      end
    end
  end
end
