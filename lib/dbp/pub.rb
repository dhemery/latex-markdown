#!/usr/bin/env ruby
require_relative 'pub/cli'
require_relative 'pub/compile'
require_relative 'pub/init'

module DBP
  module Pub
    class << self
      def application
        App.new
      end
    end

    class App
      COMMANDS = [DBP::Pub::Compile.new, DBP::Pub::Init.new]

      def run
        command_name = (ARGV.shift || '')
        COMMANDS.find(-> { abort help } ) { |c| c.name == command_name }.run
      end

      def help
        (['Usage:'] + COMMANDS.map { |command| "   #{command.banner}" }).join($/)
      end
    end
  end
end
