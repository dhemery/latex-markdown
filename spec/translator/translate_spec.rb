require_relative '../spec_helper'
require 'tex2md/translator'


describe TeX2md::Translator do
  subject { TeX2md::Translator.new }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  describe 'copies' do
    describe 'plain text' do
      let(:input) { 'some text with no commands' }

      it 'verbatim' do
        subject.translate(reader, writer)

        _(writer.string).must_equal input
      end
    end

    describe 'the argument of \markdown' do
      let(:input) { 'Before\markdown{---}after'}
      it 'verbatim' do
        subject.translate(reader, writer)

        _(writer.string).must_equal 'Before---after'
      end
    end
  end

  %w(longpage longpar shortpage shortpar).each do |macro|
    describe 'discards' do
      let(:input) { "Before \\#{macro} after" }

      it "\\#{macro}" do
        subject.translate(reader, writer)

        _(writer.string).must_equal 'Before  after'
      end
    end
  end

  %w(longpages shortpages).each do |macro|
    describe 'discards' do
      let(:input) { "Before \\#{macro}{3} after" }

      it "\\#{macro} and its argument" do
        subject.translate(reader, writer)

        _(writer.string).must_equal 'Before  after'
      end
    end
  end

  %w(abbr emph leadin unbreakable).each do |macro|
    describe "wraps the argument of \\#{macro}" do
      let(:input) { "Before \\#{macro}{argument} after" }

      it "in span.#{macro}" do
        subject.translate(reader, writer)

        _(writer.string).must_equal %Q[Before <span class='#{macro}'>argument</span> after]
      end
    end
  end

  %w(dedication quote signature).each do |environment|
    describe "wraps the content between \\begin{#{environment}} and \\end{#{environment}}" do
      let(:input) { "Before \\begin{#{environment}}in the environment\\end{#{environment}} after" }

      it "in div.#{environment}" do
        subject.translate(reader, writer)

        _(writer.string).must_equal %Q[Before <div class='#{environment}'>in the environment</div> after]
      end
    end
  end

  describe 'wraps the argument of \story' do
    let(:input) { 'Before \story{story title} after' }
    it 'in h1.story' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <h1 class='story'>story title</h1> after]
    end
  end

  describe 'wraps the argument of \chapter' do
    let(:input) { 'Before \chapter{chapter title} after' }
    it 'in h2.chapter' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <h2 class='chapter'>chapter title</h2> after]
    end
  end

  describe 'wraps the argument of \introduction' do
    let(:input) { 'Before \introduction{introduction title} after' }
    it 'in h2.introduction' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <h2 class='introduction'>introduction title</h2> after]
    end
  end

  describe 'wraps the argument of \note' do
    let(:input) { 'Before \note{note title} after' }
    it 'in h3.note' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <h3 class='note'>note title</h3> after]
    end
  end

  describe 'nests the output of' do
    let(:input) { 'Before \chapter{My \emph{great \abbr{TBD}} adventure} after' }
    it 'nested macro calls' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <h2 class='chapter'>My <span class='emph'>great <span class='abbr'>TBD</span></span> adventure</h2> after]
    end
  end

  describe 'replaces tilde' do
    let(:input) { 'Before~after' }
    it 'with a space' do
      subject.translate(reader, writer)

      _(writer.string).must_equal 'Before after'
    end
  end
end
