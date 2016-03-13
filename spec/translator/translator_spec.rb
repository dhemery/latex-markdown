$LOAD_PATH.unshift '../lib'

require 'translator'

require_relative '../spec_helper'

describe Translator do
  subject { Translator.new }

  describe 'copy text' do
    it 'sets current command to CopyText with command in text pattern' do
      subject.copy_text
      subject.current_command.must_be_instance_of CopyText
      subject.current_command.pattern.must_equal Translator::COMMAND_IN_TEXT
    end
  end
end