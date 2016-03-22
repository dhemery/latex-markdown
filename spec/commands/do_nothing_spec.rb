$LOAD_PATH.unshift '../lib'

require 'do_nothing'

require_relative '../spec_helper'

describe DoNothing do
  subject { DoNothing.new macro_name }
  let(:macro_name) { 'mymacro' }
  let(:input) { 'not to be consumed' }
  let(:original_output) { 'not to be appended' }
  let(:output) { StringIO.new original_output }
  let(:scanner) { StringScanner.new input }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes no input' do
    subject.execute(translator, scanner, output)

    scanner.rest.must_equal input
  end

  it 'writes nothing' do
    subject.execute(translator, scanner, output)

    output.string.must_equal original_output
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command' do
      translator.expect :finish_command, nil

      subject.execute translator, input, output
    end
  end
end
