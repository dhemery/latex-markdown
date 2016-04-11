require_relative '../../../spec_helper'
require 'dbp/tex2md/execute_command'

require 'strscan'

module DBP::TeX2md
  describe ExecuteCommand do
    subject { ExecuteCommand.new(pattern) }
    let(:input) { 'foo123' }
    let(:pattern) { /[[:alpha:]]+/ }

    let(:translator) do
      Object.new.tap do |allowing|
        def allowing.execute_command(_)
          ;
        end
      end
    end
    let(:reader) { StringScanner.new input }
    let(:writer) { StringIO.new }

    it 'identifies itself as \\' do
      subject.name.must_equal '\\'
    end

    it 'consumes the matching input' do
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

      it 'execute the command with the scanned name' do
        translator.expect :execute_command, nil, ['foo']

        subject.execute(translator, reader, writer)
      end
    end
  end
end
