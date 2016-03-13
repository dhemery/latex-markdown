$LOAD_PATH.unshift '../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator do
  subject { Translator.new }

  describe 'copy text' do
    it 'sets current command to CopyText interrupted by text commands' do
      subject.copy_text
      subject.current_command.must_be_instance_of CopyText
      subject.current_command.pattern.must_equal Translator::TEXT_COMMAND
    end
  end

  describe 'copy argument' do
    it 'sets current command to CopyText interrupted by argument commands' do
      subject.copy_argument
      subject.current_command.must_be_instance_of CopyText
      subject.current_command.pattern.must_equal Translator::ARGUMENT_COMMAND
    end
  end

  describe 'read command' do
    it 'sets the current command to read command with the given pattern' do
      subject.read_command /foo/
      subject.current_command.must_be_instance_of ReadCommand
      subject.current_command.pattern.must_equal /foo/
    end
  end
end