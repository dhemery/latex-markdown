require 'tex2md/app/command_line'

options = CommandLine.parse

puts "#{options.source} does not exist. Abort." unless options.source.exist?
puts "#{options.source} is a file. I will translate it." if options.source.file?
puts "#{options.source} is a directory. I will translate all .tex files in it." if options.source.directory?

puts "#{options.dest} is a directory. I will put markdown files in it." if options.dest.directory?
puts "#{options.dest} does not exist. I will create a directory there." unless options.dest.exist?
puts "#{options.dest} is a file. Abort." if options.dest.file?
