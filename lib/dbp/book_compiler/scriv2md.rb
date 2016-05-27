require 'dbp/scrivener/project'
require 'dbp/book_compiler/util/cli'

require 'open3'
require 'yaml'

module DBP
  module BookCompiler
    class Scriv2Md
      include Open3
      include CLI

      HEADINGS = %w(wtf chapter scene)

      def initialize
        super 'scriv2md'
      end

      def run
        parse_command_line do |operands|
          complain unless operands.length == 2
          @mss_source = Pathname(operands.shift)
          @manuscript_dir = Pathname(operands.shift) / 'manuscript'
        end

        scrivener = DBP::Scrivener::Project.new(@mss_source)
        write_listing_file(scrivener)
        write_md_files(scrivener)
      end

      def declare_options(p)
        p.banner << ' file dir'
      end

      def check_options(errors)
        errors << "No such scrivener file: #{@mss_source}" unless @mss_source.directory?
      end

      def write_md_files(scrivener)
        scrivener.documents.each { |document| write_md_file(document) }
      end

      def write_md_file(document)
        md_path(document).open('w') do |f|
          f.puts yaml_header(document), '...'
          f.write md_content(document)
        end
      end

      private

      def md_content(document)
        capture2('rtf2md', document.rtf_path.to_s).first
      end

      def md_path(document)
        @manuscript_dir / document.path.sub_ext('.md')
      end

      def yaml_header(document)
        document.header.tap do |header|
          header['style'] = HEADINGS[header['depth']]
          header['guide'] ='start' if header['position'] == 1 && header['depth'] == 1
        end.to_yaml
      end

      def write_listing_file(scrivener)
        listing_file = @manuscript_dir / '_listing.yaml'
        listing_file.dirname.mkpath
        listing_file.open('w') do |l|
          l.puts scrivener.documents.map { |doc| doc.path.sub_ext('').to_s }.to_yaml
          l.puts '...'
        end
      end
    end
  end
end