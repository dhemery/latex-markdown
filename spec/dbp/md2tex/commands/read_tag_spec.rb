require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/read_tag'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe ReadTag do
    subject { ReadTag.new }
    let(:translator) do
      Object.new.tap do |t|
        [:execute_tag].each { |m| t.define_singleton_method(m) {|_|} }
      end
    end
    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }

    describe 'with an open comment tag' do
      let(:input) { '<!--some comment text-->' }

      it 'consumes the open comment marker' do
        subject.execute(translator, reader, writer)

        value(reader.rest).must_equal 'some comment text-->'
      end

      it 'writes no output' do
        subject.execute(translator, reader, writer)

        value(writer.string).must_be_empty
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'execute the <!--- tag' do
          translator.expect :execute_tag, nil, ['<!--']

          subject.execute(translator, reader, writer)
        end
      end
    end

    describe 'with an open tag' do
      let(:input) { '<foo attr="attrval">' }

      it 'consumes through the tag name' do
        subject.execute(translator, reader, writer)

        value(reader.rest).must_equal ' attr="attrval">'
      end

      it 'writes no output' do
        subject.execute(translator, reader, writer)

        value(writer.string).must_be_empty
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'execute the tag with the scanned name' do
          translator.expect :execute_tag, nil, ['<foo']

          subject.execute(translator, reader, writer)
        end
      end
    end

    describe 'with a close tag' do
      let(:input) { '</foo>after' }

      it 'consumes the close tag' do
        subject.execute(translator, reader, writer)

        value(reader.rest).must_equal 'after'
      end

      it 'writes no output' do
        subject.execute(translator, reader, writer)

        value(writer.string).must_be_empty
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'execute the scanned close tag' do
          translator.expect :execute_tag, nil, ['</foo>']

          subject.execute(translator, reader, writer)
        end
      end
    end
  end
end
