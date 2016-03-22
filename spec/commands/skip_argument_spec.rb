$LOAD_PATH.unshift '../lib'

require 'skip_argument'

require_relative '../spec_helper'

describe SkipArgument do
  subject { SkipArgument.new macro_name }
  let(:macro_name) { 'mymacro' }
  let(:input) { '{argument text}additional text' }
  let(:original_output) { 'not to be appended' }
  let(:output) { StringIO.new original_output }
  let(:scanner) { StringScanner.new input }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes the left brace' do
    subject.execute(translator, scanner, output)

    scanner.rest.must_equal 'argument text}additional text'
  end

  it 'writes nothing' do
    subject.execute(translator, scanner, output)

    output.string.must_equal original_output
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and skip the next argument' do
      translator.expect :finish_command, nil
      translator.expect :skip_argument, nil

      subject.execute translator, scanner, output
    end
  end
end
