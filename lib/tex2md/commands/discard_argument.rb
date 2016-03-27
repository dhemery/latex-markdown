require_relative 'command.rb'

module TeX2md
  class DiscardArgument
    include Command

    def initialize(name)
      @name = name
      @pattern = /[^}]*}/
    end

    def to_s
      "#{self.class}(#{name})"
    end
  end
end