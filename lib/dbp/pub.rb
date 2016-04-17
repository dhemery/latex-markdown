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
      NAME = Pathname($0).basename
      COMMANDS = [DBP::Pub::Compile.new(NAME), DBP::Pub::Init.new(NAME)]

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
