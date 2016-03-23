$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator, 'translates' do
  subject { Translator.new }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  describe 'plain text' do
    let(:input) { 'some text with no commands' }

    it 'by copying it' do
      subject.translate(reader, writer)

      writer.string.must_equal input
    end
  end

  %w(longpage longpar shortpage shortpar).each do |macro|
    describe "\\#{macro}" do
      let(:input) { "Before \\#{macro} after" }

      it 'by ignoring it' do
        subject.translate(reader, writer)

        writer.string.must_equal 'Before  after'
      end
    end
  end

  %w(longpages shortpages).each do |macro|
    describe "\\#{macro}{n}" do
      let(:input) { "Before \\#{macro}{3} after" }

      it 'by ignoring it and its argument' do
        subject.translate(reader, writer)

        writer.string.must_equal 'Before  after'
      end
    end
  end

  %w(abbr emph leadin unbreakable).each do |macro|
    describe "\\#{macro}" do
      let(:input) { "Before \\#{macro}{argument} after" }

      it "by writing the argument in a span with class #{macro}" do
        subject.translate(reader, writer)

        writer.string.must_equal %Q[Before <span class='#{macro}'>argument</span> after]
      end
    end
  end
end
