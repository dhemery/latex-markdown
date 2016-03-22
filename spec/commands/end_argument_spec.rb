$LOAD_PATH.unshift '../lib'

require 'end_argument'

require_relative '../spec_helper'

describe EndArgument do
  subject { EndArgument.new }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself as }' do
    subject.name.must_equal '}'
  end

  it 'consumes no input' do
    input = 'not to be consumed'
    scanner = StringScanner.new input

    subject.execute(translator, input, nil)

    scanner.rest.must_equal input
  end

  it 'writes no output' do
    previous_output = 'previous output'
    output = StringIO.new previous_output

    subject.execute(translator, nil, output)

    output.string.must_equal previous_output
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and the previous command' do
      translator.expect :finish_command, nil
      translator.expect :finish_command, nil

      subject.execute translator, nil, nil
    end
  end
end
