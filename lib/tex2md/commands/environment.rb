require_relative 'command.rb'

module TeX2md
  class Environment
    include Command

    def initialize(name)
      @name = name
      @pattern = /}/
    end

    def write(writer, _)
      writer.write("<div class='#{name}'>")
    end

    def transition(translator, _)
      translator.copy_text
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end