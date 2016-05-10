require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/comment'

require 'strscan'

module DBP::BookCompiler::MarkdownToTex
  describe Comment do
    subject { Comment.new }
    let(:translator) do
      Object.new.tap do |t|
        # [:copy_argument_text].each { |m| t.define_singleton_method(m) {} }
      end
    end
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }
    let(:input) { '   some comment content   -->after' }

    it 'consumes the comment' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal 'after'
    end

    it 'writes the stripped comment' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_equal 'some comment content'
    end

    describe 'tells the translator' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'nothing' do
        subject.execute(translator, reader, writer)
      end
    end
  end
end
