require_relative '../spec_helper'
require 'tex2md/commands/read_command'

require 'strscan'

describe TeX2md::ReadCommand do
  subject { TeX2md::ReadCommand.new(pattern) }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.execute_command(_) ; end
      def allowing.finish_command ; end
    end
  end
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  describe 'when the input has a name that matches the pattern' do
    let(:input) { 'foo123' }
    let(:pattern) { /[[:alpha:]]+/ }

    it 'consumes the name' do
      subject.execute(translator, reader, writer)

      value(reader.rest).must_equal '123'
    end

    it 'writes no output' do
      subject.execute(translator, reader, writer)

      value(writer.string).must_be_empty
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'execute the named command' do
        translator.expect :execute_command, nil, ['foo']

        subject.execute(translator, reader, writer)
      end
    end
  end

  describe 'when the input does not match the pattern' do
    let(:input) { '123' }
    let(:pattern) { /[[:alpha:]]+/ }

    it 'consumes no input' do
      subject.execute(translator, reader, writer)

      _(reader.rest).must_equal input
    end

    it 'writes no output' do
      subject.execute(translator, reader, writer)

      _(writer.string).must_be_empty
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }
      after { translator.verify }

      it 'execute the nil command' do
        translator.expect :execute_command, nil, [nil]

        subject.execute(translator, reader, writer)
      end
    end
  end
end
