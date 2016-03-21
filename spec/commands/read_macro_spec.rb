$LOAD_PATH.unshift '../lib'

require 'read_macro'

require_relative '../spec_helper'

require 'strscan'

describe ReadMacro do
  subject { ReadMacro.new }
  let(:translator) { FakeTranslator.new }
  let(:scanner) { StringScanner.new input }
  let(:input) { 'some input' }

  it 'identifies itself as \\' do
    subject.name.must_equal '\\'
  end

  it 'consumes no input' do
    subject.execute translator, scanner, nil

    scanner.rest.must_equal input
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command and read an alphabetic command' do
      translator.expect :finish_command, nil
      translator.expect :read_command, nil, [/[[:alpha:]]+/]

      subject.execute translator, scanner, nil
    end
  end
end
