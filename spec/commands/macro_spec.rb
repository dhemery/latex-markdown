$LOAD_PATH.unshift '../lib'

require 'macro'

require_relative '../spec_helper'

describe Macro do
  subject { Macro.new macro_name }
  let(:macro_name) { 'mymacro' }
  let(:input) { '{argument text}additional text' }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'argument text}additional text'
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and copy the argument' do
      translator.expect :finish_command, nil
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
