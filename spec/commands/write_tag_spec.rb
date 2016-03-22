$LOAD_PATH.unshift '../lib'

require 'write_tag'

require_relative '../spec_helper'

require 'strscan'

describe WriteTag do
  subject { WriteTag.new(tag, type) }
  let(:tag) { 'foo' }
  let(:type) { 'bar' }
  let(:input) { 'not to be consumed' }
  let(:translator) { FakeTranslator.new }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself by type' do
    subject.name.must_equal type
  end

  it 'consumes no input' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal input
  end

  it 'writes the open tag with the type as its class' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal "<#{tag} class='#{type}'>"
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command, copy the argument, and write the end tag' do
      translator.expect :finish_command, nil
      translator.expect :write_text, nil, ["</#{tag}>"]
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
