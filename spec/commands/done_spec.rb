$LOAD_PATH.unshift '../lib'

require 'done'

require_relative '../spec_helper'

describe Done do
  subject { Done.new }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself as nil' do
    subject.name.must_be_nil
  end
  
  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command, copy the argument, and write the end tag' do
      translator.expect :finish_document, nil

      subject.execute translator, nil, nil
    end
  end
end
