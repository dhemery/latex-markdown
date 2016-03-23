$LOAD_PATH.unshift '../lib'

require 'element_macro'

require_relative '../spec_helper'

require 'strscan'

describe ElementMacro do
  subject { ElementMacro.new(macro_name, element) }
  let(:macro_name) { 'bar' }
  let(:element) { 'foo' }
  let(:input) { '{argument}' }
  let(:translator) { FakeTranslator.new }
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    subject.name.must_equal macro_name
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'argument}'
  end

  it 'writes the open tag with the type as its class' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal "<#{element} class='#{macro_name}'>"
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command, copy the argument, and write the end tag' do
      translator.expect :finish_command, nil
      translator.expect :write_text, nil, ["</#{element}>"]
      translator.expect :copy_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
