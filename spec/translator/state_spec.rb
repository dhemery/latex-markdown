require_relative '../spec_helper'
require 'tex2md/translator'

describe TeX2md::Translator, 'state' do
  subject { TeX2md::Translator.new(stack) }
  let(:stack) { MiniTest::Mock.new }

  after { stack.verify }

  describe 'copy argument' do
    it 'pushes CopyText with the argument pattern' do
      stack.expect :push, nil, [TeX2md::CopyText.new(TeX2md::Translator::ARGUMENT_PATTERN)]

      subject.copy_argument
    end
  end

  describe 'copy text' do
    it 'pushes CopyText with the given pattern' do
      pattern = /[[:print:]]+/

      stack.expect :push, nil, [TeX2md::CopyText.new(pattern)]

      subject.copy_text(pattern)
    end
  end

  describe 'finish command' do
    it 'pops one command off the stack' do
      stack.expect :pop, nil

      subject.finish_command
    end
  end

  describe 'finish document' do
    it 'clears the stack' do
      stack.expect :clear, nil

      subject.finish_document
    end
  end

  describe 'read command' do
    it 'pushes ReadCommand with the command pattern' do
      stack.expect :push, nil, [TeX2md::ReadCommand.new(nil, TeX2md::Translator::COMMAND_PATTERN)]

      subject.read_command
    end
  end

  describe 'resume' do
    let(:command) { Object.new }

    it 'pushes the command' do
      stack.expect :push, nil, [command]

      subject.resume(command)
    end
  end

  describe 'write text' do
    it 'pushes an anonymous WriteText with the given text' do
      text = 'some text to write'

      stack.expect :push, nil, [TeX2md::WriteTextMacro.new(nil, text)]

      subject.write_text text
    end
  end
end
