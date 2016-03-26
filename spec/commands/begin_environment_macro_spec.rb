require_relative '../spec_helper'
require 'tex2md/commands/begin_environment_macro'

require 'strscan'

describe TeX2md::BeginEnvironmentMacro do
  subject { TeX2md::BeginEnvironmentMacro.new }
  let(:argument) { 'myenvironment' }
  let(:input) { "{#{argument}}some text\end{#{argument}}" }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.copy_text ; end
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

    it 'finish the current command and copy text' do
      translator.expect :finish_command, nil
      translator.expect :copy_text, nil

      subject.execute(translator, reader, writer)
    end
  end
end
