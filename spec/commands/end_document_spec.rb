$LOAD_PATH.unshift '../lib'

require 'end_document'

require_relative '../spec_helper'

describe EndDocument do
  subject { EndDocument.new }
  let(:translator) { FakeTranslator.new }

  it 'identifies itself as nil' do
    subject.name.must_be_nil
  end
  
  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the document' do
      translator.expect :finish_document, nil

      subject.execute translator, nil, nil
    end
  end
end
