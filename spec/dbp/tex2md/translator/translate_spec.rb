require_relative '_helper'
require 'dbp/book_compiler/tex_to_markdown/translator'

module DBP::BookCompiler::TexToMarkdown
  describe Translator do
    subject { Translator.new }
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    describe 'copies' do
      let(:input) { 'some text with no commands' }

      it 'plain text' do
        subject.translate(reader, writer)

        _(writer.string).must_equal input
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
        let(:input) { 'before \break after' }
        it 'with <br />' do
          subject.translate(reader, writer)

          _(writer.string).must_equal 'before <br /> after'
        end
      end

      describe '\markdown' do
        let(:input) { 'Before\markdown{---}after' }
        it 'with its argument' do
          subject.translate(reader, writer)

          _(writer.string).must_equal 'Before---after'
        end
      end

      describe '\$' do
        let(:input) { 'Before\$after' }
        it 'with $' do
          subject.translate(reader, writer)

          _(writer.string).must_equal 'Before$after'
        end
      end
    end

    describe 'discards' do
      %w(longpage longpar shortpage shortpar).each do |macro|
        describe "\\#{macro}" do
          let(:input) { "Before \\#{macro} after" }

          it do
            subject.translate(reader, writer)

            _(writer.string).must_equal 'Before  after'
          end
        end
      end

      %w(longpages shortpages).each do |macro|
        describe "\\#{macro}" do
          let(:input) { "Before \\#{macro}{3} after" }

          it 'and its argument' do
            subject.translate(reader, writer)

            _(writer.string).must_equal 'Before  after'
          end
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
      describe "wraps the content of a #{environment} environment" do
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

        it "with #{style} as the style property" do
          subject.translate(reader, writer)

          _(writer.string.each_line(&:chomp)).must_include "style: #{style}"
        end

        it 'with its argument as the title property' do
          subject.translate(reader, writer)

          _(writer.string.each_line(&:chomp)).must_include 'title: page title'
        end
      end
    end

    describe 'translates macros' do
      let(:input) { 'Before \unbreakable{My \emph{great \break\abbr{TBD}} adventure} after' }
      it 'that appear in arguments of other macros' do
        subject.translate(reader, writer)

        _(writer.string).must_equal %q[Before <span class='unbreakable'>My <span class='emph'>great <br /><span class='abbr'>TBD</span></span> adventure</span> after]
      end
    end
  end
end
