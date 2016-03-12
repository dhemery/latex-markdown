$LOAD_PATH.unshift '../lib'

require 'reading_command'

require_relative '../spec_helper'

require 'ostruct'
require 'strscan'

describe ReadingCommand do
  let(:commands) { {} }
  let(:context) { OpenStruct.new }
  let(:output) { StringIO.new previous_output }
  let(:previous_output) { 'previous output' }
  let(:reading_command) { ReadingCommand.new(context, pattern, commands) }
  let(:scanner) { StringScanner.new input }

  before { reading_command.execute(scanner, output) }

  describe 'when the input matches the command name pattern' do
    let(:input) { 'foo123' }
    let(:pattern) { /[[:alpha:]]+/ }

    it 'consumes the matching command name' do
      scanner.rest.must_equal '123'
    end

    it 'writes nothing' do
      output.string.must_equal previous_output
    end

    describe 'and the command table includes a command with the scanned command name' do
      let(:commands) { { 'foo' => 'the foo command' } }

      it 'changes state to the command found in the command table' do
        context.state.must_be_same_as commands['foo']
      end
    end

    describe 'and the command table includes no command with the scanned command name' do
      before { commands.delete 'foo' }

      it 'changes state to copying text' do
        context.state.must_be_instance_of CopyingText
      end
    end
  end


  describe 'when the input does not match the command pattern' do
    let(:input) { StringScanner.new '\macroname{macro argument}' }
  end

end
