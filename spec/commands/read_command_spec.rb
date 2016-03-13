$LOAD_PATH.unshift '../lib'

require 'read_command'

require_relative '../spec_helper'

require 'strscan'

describe ReadCommand do
  subject { ReadCommand.new(translator, scanner, pattern) }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new previous_output }
  let(:previous_output) { 'previous output' }
  let(:scanner) { StringScanner.new input }

  describe 'when the input has a name that matches the pattern' do
    let(:input) { 'foo123' }
    let(:pattern) { /[[:alpha:]]+/ }

    it 'consumes the name' do
      subject.execute
      scanner.rest.must_equal '123'
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }

      it 'finish the current command and execute the named command' do
        translator.expect :finish_current_command, nil
        translator.expect :execute_command, nil, ['foo']
        subject.execute
      end
    end
  end

  describe 'when the input does not match the pattern' do
    let(:input) { '123' }
    let(:pattern) { /[[:alpha:]]+/ }

    it 'consumes no input' do
      subject.execute
      scanner.rest.must_equal input
    end

    describe 'tells translator to' do
      let(:translator) { MiniTest::Mock.new }

      it 'finish the current command and execute the nil command' do
        translator.expect :finish_current_command, nil
        translator.expect :execute_command, nil, [nil]
        subject.execute
      end
    end
  end
end
