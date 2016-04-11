require_relative '../../../spec_helper'
require 'dbp/tex2md/translator'

module DBP::TeX2md
  describe Translator, 'state' do
    subject { Translator.new(stack) }
    let(:stack) { MiniTest::Mock.new }

    after { stack.verify }

    describe 'copy argument' do
      it 'pushes CopyText with the argument pattern' do
        stack.expect :push, nil, [CopyText.new(Translator::ARGUMENT)]

        subject.copy_argument
      end
    end

    describe 'copy text' do
      it 'pushes CopyText with the text pattern' do
        stack.expect :push, nil, [CopyText.new(Translator::TEXT)]

        subject.copy_text
      end

      describe 'execute operator' do
        it 'pushes ExecuteCommand with the operator pattern' do
          stack.expect :push, nil, [ExecuteCommand.new(Translator::OPERATOR)]

          subject.execute_operator
        end
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

        stack.expect :push, nil, [WriteText.new(text)]

        subject.write_text text
      end
    end
  end
end