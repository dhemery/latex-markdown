require_relative '../spec_helper'
require 'tex2md/commands/end_environment'

require 'strscan'

describe TeX2md::EndEnvironment do
  subject { TeX2md::EndEnvironment.new }
  let(:input) { '{environment}' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
      def allowing.skip_argument ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself by name' do
    subject.name.must_equal 'end'
  end

  it 'consumes the left brace' do
    subject.execute(translator, reader, writer)

    reader.rest.must_equal 'environment}'
  end

  it 'writes and end div tag' do
    subject.execute(translator, reader, writer)

    writer.string.must_equal '</div>'
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the current command, finish the next command, and skip the argument' do
      translator.expect :finish_command, nil
      translator.expect :finish_command, nil
      translator.expect :skip_argument, nil

      subject.execute(translator, reader, writer)
    end
  end
end
