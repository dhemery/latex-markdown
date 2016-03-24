require 'tex2md/command_line'

options = TeX2md::CommandLine.parse

source = options.source
dest = options.dest

dest.mkpath unless dest.exist?

puts "#{source}: no such file or directory" unless source.exist?

puts "#{dest}: no such directory" unless options.dest.directory?

if dest.file? || !source.exist?
  exit 1
end

puts 'Everything is hunky dory'