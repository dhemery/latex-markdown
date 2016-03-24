require_relative 'command.rb'

module TeX2md
  class IgnoredMacro
    include Command

    def initialize(name)
      @name = name
    end

    def to_s
      "#{self.class}"
    end
  end
end