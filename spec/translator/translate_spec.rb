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

  %w(chapter note introduction story).each do |style|
    describe "converts \\#{style} into yaml" do
      let(:input) { "\\#{style}{page title}" }

      it "style property with value #{style}" do
        subject.translate(reader, writer)

        _(writer.string.each_line(&:chomp)).must_include "style: #{style}"
      end

      it 'title property with the argument as its value' do
        subject.translate(reader, writer)

        _(writer.string.each_line(&:chomp)).must_include 'title: page title'
      end
    end
  end

  describe 'nests the output of' do
    let(:input) { 'Before \unbreakable{My \emph{great \break\abbr{TBD}} adventure} after' }
    it 'nested macro calls' do
      subject.translate(reader, writer)

      _(writer.string).must_equal %q[Before <span class='unbreakable'>My <span class='emph'>great <br /><span class='abbr'>TBD</span></span> adventure</span> after]
    end
  end

  describe 'replaces' do
    describe 'tilde' do
      let(:input) { 'Before~after' }
      it 'with a space' do
        subject.translate(reader, writer)

        _(writer.string).must_equal 'Before after'
      end
    end

    describe '\break' do
      let(:input) { 'before \break after'}
      it 'with <br />' do
        subject.translate(reader, writer)

        _(writer.string).must_equal 'before <br /> after'
      end
    end
  end

end
