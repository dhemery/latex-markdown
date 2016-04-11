require_relative 'tex2md/command_line'
require_relative 'tex2md/app.rb'

DBP::TeX2md::App.new(DBP::TeX2md::CommandLine.parse).run
