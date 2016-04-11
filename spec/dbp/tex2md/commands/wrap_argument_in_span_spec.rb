require_relative '../../../spec_helper'
require 'dbp/tex2md/wrap_argument_in_span'

require 'strscan'

module DBP
  module TeX2md
    describe WrapArgumentInSpan do
      subject { WrapArgumentInSpan.new(macro) }
      let(:macro) { 'myspanmacro' }
      let(:input) { '{argument}' }
      let(:translator) do
        Object.new.tap do |allowing|
          def allowing.copy_argument;
          end

          def allowing.write_text(_)
            ;
          end
        end
      end
      let(:reader) { StringScanner.new(input) }
      let(:writer) { StringIO.new }

      it 'identifies itself by its name' do
        _(subject.name).must_equal macro
      end

      it 'consumes the left brace' do
        subject.execute(translator, reader, writer)

        _(reader.rest).must_equal 'argument}'
      end

      it 'writes the open span tag with the macro name as its class' do
        subject.execute(translator, reader, writer)

        _(writer.string).must_equal "<span class='#{macro}'>"
      end

      describe 'tells translator to' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'copy the argument and write the end span tag' do
          translator.expect :write_text, nil, ['</span>']
          translator.expect :copy_argument, nil

          subject.execute(translator, reader, writer)
        end
      end
    end
  end
end
