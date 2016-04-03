require_relative '../spec_helper'
require 'tex2md/commands/exit_environment'

require 'strscan'

describe TeX2md::ExitEnvironment do
  subject { TeX2md::ExitEnvironment.new }
  let(:input) { '{environment}remaining text' }
  let(:translator) do
    Object.new.tap do |allowing|
      def allowing.finish_command ; end
    end
  end
  let(:reader) { StringScanner.new(input) }
  let(:writer) { StringIO.new }

  it 'identifies itself as end' do
    _(subject.name).must_equal 'end'
  end

  it 'consumes the argument' do
    subject.execute(translator, reader, writer)

    _(reader.rest).must_equal 'remaining text'
  end

  it 'writes and end div tag' do
    subject.execute(translator, reader, writer)

    _(writer.string).must_equal '</div>'
  end

  describe 'tells translator to' do
    let(:translator) { MiniTest::Mock.new }
    after { translator.verify }

    it 'finish the command that the \end interrupted' do
      translator.expect :finish_command, nil

      subject.execute(translator, reader, writer)
    end
  end
end
