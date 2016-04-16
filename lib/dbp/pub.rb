#!/usr/bin/env ruby
require_relative 'pub/cli'
require_relative 'pub/compile'
require_relative 'pub/init'

module DBP
  module Pub
    COMMANDS = [DBP::Pub::Compile.new, DBP::Pub::Init.new]

    class << self
      def run
        command_name = (ARGV.shift || '')
        command = COMMANDS.find { |c| c.name == command_name }
        abort help.join($/) unless command
        command.run
      end

      def help
        COMMANDS.map { |command| "#{command.banner}" }
      end
    end
  end
end
