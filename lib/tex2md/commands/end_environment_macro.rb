require_relative 'command.rb'

module TeX2md
  class EndEnvironmentMacro
    include Command

    def initialize
      @name = 'end'
      @pattern = /{/
    end

    def write(writer, _)
      writer.write('</div>')
    end

    def transition(translator, _)
      translator.finish_command
      translator.skip_argument
    end

    def to_s
      "#{self.class}"
    end
  end
end