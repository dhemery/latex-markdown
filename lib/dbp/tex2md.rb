require_relative 'tex2md/command_line'
require_relative 'tex2md/translator'

require 'strscan'

def dest_file(dest_dir, source_file)
  Pathname.new("#{dest_dir / source_file.basename('.tex')}.md")
end

def tex_files_in(source)
  Dir.glob(source / '**/*.tex').map { |p| Pathname.new(p) }
end

def source_files(source)
  return [source] if source.file?
  tex_files_in(source) if source.directory?
end

def validate_args(dest_dir, source)
  puts "#{source}: no such file or directory" unless source.exist?
  puts "#{dest_dir}: is a file" if dest_dir.file?

  if dest_dir.file? || !source.exist?
    exit 1
  end
end

options = DBP::TeX2md::CommandLine.parse

source = options.source
dest_dir = options.dest

validate_args(dest_dir, source)

dest_dir.mkpath unless dest_dir.exist?

translator = DBP::TeX2md::Translator.new

source_files = source_files(source)

source_files.each do |source_file|
  dest_file = dest_file(dest_dir, source_file)
  reader = StringScanner.new(source_file.read)
  dest_file.open('w') do |writer|
    translator.translate(reader, writer)
  end
end
