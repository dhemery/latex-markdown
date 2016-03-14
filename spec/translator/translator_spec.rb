$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator do
  subject { Translator.new('', nil) }

  describe 'copy text' do
    it 'pushes CopyText interrupted by text command' do
      subject.copy_text
      current_command = subject.stack.last
      current_command.must_be_instance_of CopyText
      current_command.pattern.must_equal Translator::TEXT_COMMAND_PATTERN
    end
  end

  describe 'copy argument' do
    it 'pushes CopyText interrupted by any command' do
      subject.copy_argument
      current_command = subject.stack.last
      current_command.must_be_instance_of CopyText
      current_command.pattern.must_equal Translator::COMMAND_PATTERN
    end
  end

  describe 'read command' do
    it 'pushes ReadCommand' do
      subject.read_command
      current_command = subject.stack.last
      current_command.must_be_instance_of ReadCommand
    end
  end

  describe 'finish current command' do
    it 'pops' do
      subject.copy_text # to put a command on the stack
      subject.finish_current_command
      subject.stack.must_be :empty?
    end
  end
end
