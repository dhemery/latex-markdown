require_relative '../spec_helper'
require 'commands/ignored_arg_macro'

describe IgnoredArgMacro do
  subject { IgnoredArgMacro.new macro_name }
  let(:macro_name) { 'mymacro' }
  let(:input) { '{argument text}additional text' }
  let(:translator) { FakeTranslator.new }
  let(:reader) { StringScanner.new input }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'argument text}additional text'
  end

  it 'writes nothing' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and skip the argument' do
      translator.expect :finish_command, nil
      translator.expect :skip_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
