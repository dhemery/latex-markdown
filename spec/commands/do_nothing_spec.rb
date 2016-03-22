$LOAD_PATH.unshift '../lib'

require 'do_nothing'

require_relative '../spec_helper'

describe DoNothing do
  subject { DoNothing.new macro_name }
  let(:macro_name) { 'mymacro' }
  let(:input) { 'not to be consumed' }
  let(:writer) { StringIO.new }
  let(:reader) { StringScanner.new input }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal input
  end

  it 'writes no output' do
    subject.execute(translator, reader, writer)

    writer.string.must_be_empty
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command' do
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
