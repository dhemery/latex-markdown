require_relative '../spec_helper'
require 'tex2md/translator'


describe TeX2md::Translator, 'translates' do
  subject { TeX2md::Translator.new }
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

  %w(dedication quote signature).each do |environment|
    describe environment do
      let(:input) { "Before \\begin{#{environment}}in the environment\\end{#{environment}} after" }

      it "by writing the contents in a div with class #{environment}" do
        subject.translate(reader, writer)

        writer.string.must_equal %Q[Before <div class='#{environment}'>in the environment</div> after]
      end
    end
  end

  describe '\\story' do
    let(:input) { 'Before \\story{story title} after' }
    it 'by writing the argument in an h1 with class story' do
      subject.translate(reader, writer)

      writer.string.must_equal %q[Before <h1 class='story'>story title</h1> after]
    end
  end

  describe '\\chapter' do
    let(:input) { 'Before \\chapter{chapter title} after' }
    it 'by writing the argument in an h2 with class chapter' do
      subject.translate(reader, writer)

      writer.string.must_equal %q[Before <h2 class='chapter'>chapter title</h2> after]
    end
  end

  describe '\\introduction' do
    let(:input) { 'Before \\introduction{introduction title} after' }
    it 'by writing the argument in an h2 with class introduction' do
      subject.translate(reader, writer)

      writer.string.must_equal %q[Before <h2 class='introduction'>introduction title</h2> after]
    end
  end

  describe '\\note' do
    let(:input) { 'Before \\note{note title} after' }
    it 'by writing the argument in an h3 with class note' do
      subject.translate(reader, writer)

      writer.string.must_equal %q[Before <h3 class='note'>note title</h3> after]
    end
  end

  describe 'nested macro calls' do
    let(:input) { 'Before \chapter{My \emph{great \abbr{TBD}} adventure} after' }
    it 'by translating each call' do
      subject.translate(reader, writer)

      writer.string.must_equal %q[Before <h2 class='chapter'>My <span class='emph'>great <span class='abbr'>TBD</span></span> adventure</h2> after]
    end
  end
end
