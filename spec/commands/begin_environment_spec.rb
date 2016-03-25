require_relative '../spec_helper'
require 'tex2md/commands/begin_environment'

require 'strscan'

describe TeX2md::BeginEnvironment do
  subject { TeX2md::BeginEnvironment.new }
  let(:input) { '{environment}some text\end{environment}' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.read_macro ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself as begin' do
    subject.name.must_equal 'begin'
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'environment}some text\end{environment}'
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and read a macro' do
      translator.expect :finish_command, nil
      translator.expect :read_macro, nil

      subject.execute(translator, reader, writer)
    end
  end
end
