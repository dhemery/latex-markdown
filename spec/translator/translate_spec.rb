$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator, 'translate' do
  subject { Translator.new }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  describe 'copies' do
    let(:input) { 'some text with no commands' }

    it 'plain text' do
      subject.translate(reader, writer)

      writer.string.must_equal input
    end
  end

  describe 'ignores' do
    %w(longpage longpar shortpage shortpar).each do |m|
      let(:input) { "Some text\\#{m}" }

      it "\\#{m}" do
        subject.translate(reader, writer)

        writer.string.must_equal 'Some text'
      end
    end

    %w(longpages shortpages).each do |m|
      let(:input) { "Some text\\#{m}{3}" }
      it "\\#{m}{n}" do
        subject.translate(reader, writer)

        writer.string.must_equal 'Some text'
      end
    end
  end

  describe 'replaces' do
    let(:input) { "Some \\emph{emphasized} text" }
    it '\\emph' do
      skip 'TODO: CopyArgument'
      subject.translate(reader, writer)

      writer.string.must_equal %q[Some <span class='emph'>emphasized</span> text]
    end
  end
end
