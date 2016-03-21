$LOAD_PATH.unshift '../../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator do
  subject { Translator.new('', nil, []) }

  describe 'copy text' do
    it 'pushes CopyText interrupted by text command' do
      subject.copy_text
      current_command = subject.stack.last
      current_command.must_be_instance_of CopyText
      current_command.pattern.must_equal Translator::TEXT_PATTERN
    end
  end

  describe 'copy argument' do
    it 'pushes CopyText interrupted by any command' do
      subject.copy_argument
      current_command = subject.stack.last
      current_command.must_be_instance_of CopyText
      current_command.pattern.must_equal Translator::ARGUMENT_PATTERN
    end
  end

  describe 'read command' do
    it 'pushes ReadCommand' do
      subject.read_command
      current_command = subject.stack.last
      current_command.must_be_instance_of ReadCommand
    end
  end

  describe 'finish command' do
    it 'pop the stack' do
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.finish_command
      subject.stack.size.must_equal(2)
    end
  end

  describe 'finish document' do
    it 'clears the stack' do
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.copy_text # to put a command on the stack
      subject.finish_document
      subject.stack.must_be :empty?
    end
  end
end
