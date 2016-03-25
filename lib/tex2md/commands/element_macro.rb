require_relative 'command.rb'

module TeX2md
  class ElementMacro
    include Command
    attr_reader :element

    def initialize(name, element)
      @name = name
      @element = element
      @pattern = /{/
    end

    def write(writer, _)
      writer.write "<#{element} class='#{name}'>"
    end

    def transition(translator, _)
      translator.write_text("</#{element}>")
      translator.copy_argument
    end

    def to_s
      "#{self.class}(#{name},#{element})"
    end
  end
end