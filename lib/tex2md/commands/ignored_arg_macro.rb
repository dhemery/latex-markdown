module TeX2md
  class IgnoredArgMacro
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def execute(translator, reader, _)
      reader.getch
      translator.finish_command
      translator.skip_argument
    end

    def to_s
      "#{self.class}"
    end
  end
end