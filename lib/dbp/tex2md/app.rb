require_relative 'translator'
require 'strscan'

module DBP::TeX2md
  class App

    def initialize(options)
      @source = Pathname(options.source)
      @dest_dir = Pathname(options.dest)
      @translator = Translator.new
    end

    def run
      validate_args

      @dest_dir.mkpath unless @dest_dir.exist?

      source_files.each do |source_file|
        dest_file = dest_file(source_file)
        reader = StringScanner.new(source_file.read)
        dest_file.open('w') do |writer|
          @translator.translate(reader, writer)
        end
      end
    end

    def dest_file(source_file)
      Pathname.new("#{@dest_dir / source_file.basename('.tex')}.md")
    end

    def tex_files_in(source)
      Dir.glob(source / '**/*.tex').map { |p| Pathname.new(p) }
    end

    def source_files
      return [@source] if @source.file?
      tex_files_in(@source) if @source.directory?
    end

    def validate_args
      errors = []
      errors << "#{@source}: no such file or directory" unless @source.exist?
      errors << "#{@dest_dir}: is a file" if @dest_dir.file?
      abort(errors) unless errors.empty?
    end
  end
end