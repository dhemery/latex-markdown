require_relative '_helper'
require 'dbp/book_compiler/markdown_to_tex/operators/toggle'

module DBP::BookCompiler::MarkdownToTex
  describe Toggle do
    subject { Toggle.new(toggles) }
    let(:captured) { '*' }
    let(:macro) { 'emph' }
    let(:toggle) { { name: captured, macro: macro } }
    let(:toggles) { [ toggle ] }

    describe 'with toggle disabled' do
      before { toggle[:enabled] = false }

      describe 'tells the translator to' do
        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'write the open macro text and enter copy_text state' do
          translator.expect :write, nil, ["\\#{macro}{"]
          translator.expect :enter, nil, [:copying_text]

          subject.execute(translator, captured)
        end
      end

      describe 'sets toggle state to' do
        let(:translator) do
          Object.new.tap do |t|
            [:write, :enter].each { |m| t.define_singleton_method(m) { |_| } }
          end
        end

        it 'enabled' do
          subject.execute(translator, captured)

          _(toggle[:enabled]).must_equal true
        end
      end
    end

    describe 'with toggle enabled' do
      before { toggle[:enabled] = true }

      describe 'tells the translator to' do

        let(:translator) { MiniTest::Mock.new }
        after { translator.verify }

        it 'write the close macro text and enter copy_text state' do
          translator.expect :write, nil, ['}']
          translator.expect :enter, nil, [:copying_text]

          subject.execute(translator, captured)
        end
      end

      describe 'sets toggle state to' do
        let(:translator) do
          Object.new.tap do |t|
            [:write, :enter].each { |m| t.define_singleton_method(m) { |_| } }
          end
        end

        it 'disabled' do
          subject.execute(translator, captured)

          _(toggle[:enabled]).must_equal false
        end
      end
    end
  end
end
