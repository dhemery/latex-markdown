$LOAD_PATH.unshift '../lib'

require 'read_command'

require_relative '../spec_helper'

require 'strscan'

describe ReadCommand do
  subject { ReadCommand.new(translator, scanner, pattern, commands) }
  let(:translator) { FakeTranslator.new }
  let(:output) { StringIO.new previous_output }
  let(:previous_output) { 'previous output' }
  let(:scanner) { StringScanner.new input }

  describe 'when the input has a name that matches the pattern' do
    let(:input) { 'foo123' }
    let(:pattern) { /[[:alpha:]]+/ }

    describe 'and the command table has a command with that name' do
      let(:commands) { { 'foo' => 'the foo command' } }

      it 'consumes the name' do
        subject.execute
        scanner.rest.must_equal '123'
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new FakeTranslator.new }

        it 'execute the command' do
          translator.expect :execute_command, nil, [commands['foo']]
          subject.execute
        end
      end
    end

    describe 'and the command table has no command with that name' do
      let(:commands) { {} }

      it 'consumes the name' do
        subject.execute
        scanner.rest.must_equal '123'
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new FakeTranslator.new }

        it 'pop' do
          translator.expect :pop, nil
          subject.execute
          translator.verify
        end
      end
    end
  end
end
