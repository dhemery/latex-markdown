require_relative 'command.rb'

module TeX2md
  class Markdown
    include Command

    def initialize
      @name = 'markdown'
      @pattern = /{/
    end

    def transition(translator, _)
      translator.copy_argument
    end
  end
end