$LOAD_PATH.unshift '../lib'

require 'reading_command'

require_relative '../spec_helper'

require 'strscan'

describe ReadingCommand do
  subject { ReadingCommand.new(context, scanner, pattern, commands) }
  let(:context) { FakeContext.new }
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

      describe 'tells context to' do
        let(:context) { MiniTest::Mock.new FakeContext.new }

        it 'execute the command' do
          context.expect :execute_command, nil, [commands['foo']]
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

      describe 'tells context to' do
        let(:context) { MiniTest::Mock.new FakeContext.new }

        it 'pop' do
          context.expect :pop, nil
          subject.execute
          context.verify
        end
      end
    end
  end
end
