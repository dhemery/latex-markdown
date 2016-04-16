#!/usr/bin/env ruby
require_relative 'pub/command'
require_relative 'pub/compile'
require_relative 'pub/init'

module DBP
  module Pub
    COMMANDS = [DBP::Pub::Compile.new, DBP::Pub::Init.new].map { |app| Command.new(app) }

    class << self
      def run
        command_name = (ARGV.shift || '')
        command = COMMANDS.find { |c| c.name == command_name }
        abort usage.join($/) unless command
        command.run
      end

      def usage
        ['Usage:'] + COMMANDS.map { |command| "   pub #{command.name} [<args>]" }
      end
    end
  end
end
