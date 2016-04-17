require_relative '_helper'
require 'dbp/tex_to_markdown/enter_environment'

require 'strscan'

module DBP::TexToMarkdown
  describe EnterEnvironment do
    subject { EnterEnvironment.new }
    let(:argument) { 'myenvironment' }
    let(:input) { "{#{argument}}some text\end{#{argument}}" }
    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.copy_text;
        end
      end
    end
    let(:reader) { StringScanner.new(input) }
    let(:writer) { StringIO.new }

    it 'identifies itself as begin' do
      _(subject.name).must_equal 'begin'
    end

    it 'consumes the argument' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal "some text\end{#{argument}}"
    end

    it 'writes an opening div with the argument as its class' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_equal "<div class='#{argument}'>"
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'copy text' do
        translator.expect :copy_text, nil

        subject.execute(translator, reader, writer)
      end
    end
  end
end
