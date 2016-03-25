require_relative 'command.rb'

module TeX2md

  class Page
    include Command

    def initialize(style)
      @name = style
      @pattern = /{/
    end

    def write(writer, _)
      writer.write("style: #{name}#{$/}title: ")
    end

    def transition(translator, _)
      translator.copy_argument
    end
  end
end