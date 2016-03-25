require_relative 'command.rb'

module TeX2md
  class NullMacro
    include Command

    def initialize(name)
      @name = name
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end