require_relative 'command.rb'

module TeX2md

  class PageMacro
    include Command

    def initialize(name)
      @name = name
      @pattern = /{/
      @text = "style: #{name}#{$/}title: "
    end

    def write(writer, _)
      writer.write(@text)
    end

    def transition(translator, _)
      translator.copy_argument
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end