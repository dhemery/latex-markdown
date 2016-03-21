$LOAD_PATH.unshift '../lib'

require 'done'

require_relative '../spec_helper'

describe Done do
  subject { Done.new }
  let(:translator) { FakeTranslator.new }

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    it 'finish the current command, copy the argument, and write the end tag' do
      translator.expect :finish_document, nil
      subject.execute translator, nil, nil
      translator.verify
    end
  end
end
