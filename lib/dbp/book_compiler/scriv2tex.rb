require 'dbp/scrivener/project'
require 'dbp/book_compiler/util/cli'

require 'open3'
require 'yaml'

module DBP
  module BookCompiler
    class Scriv2TeX
      include Open3
      include CLI

      HEADINGS = %w(wtf chapter scene)

      def initialize
        super 'scriv2tex'
      end

      def run
        parse_command_line do |operands|
          complain unless operands.length == 2
          @mss_scrivener_file = Pathname(operands.shift)
          @manuscript_dir = Pathname(operands.shift) / 'manuscript'
        end

        scrivener = DBP::Scrivener::Project.new(@mss_scrivener_file)
        write_listing_file(scrivener)
        write_tex_files(scrivener)
      end

      def declare_options(p)
        p.banner << ' file dir'
      end

      def check_options(errors)
        errors << "No such scrivener file: #{@mss_scrivener_file}" unless @mss_scrivener_file.directory?
      end

      def write_tex_files(scrivener)
        scrivener.documents.each { |document| write_tex_file(document) }
      end

      def write_tex_file(document)
        tex_path(document).open('w') do |f|
          f.puts tex_header(document)
          f.write tex_content(document)
        end
      end

      private

      def tex_content(document)
        capture2('rtf2tex', document.rtf_path.to_s).first
      end


      def tex_path(document)
        @manuscript_dir / document.path.sub_ext('.tex')
      end

      def tex_header(document)
        header = document.header
        [
            '\markdown{---}',
            guide(header),
            heading(header),
            '\markdown{---}'
        ]
      end

      def heading(header)
        "\\#{HEADINGS[header['depth']]}{#{header['title']}}"
      end

      def guide(header)
        '\\markdown{guide: start}' if header['position'] == 1 && header['depth'] == 1
      end

      def write_listing_file(scrivener)
        listing_file = @manuscript_dir / 'listing.yaml'
        listing_file.dirname.mkpath
        listing_file.open('w') do |l|
          l.puts scrivener.documents.map { |doc| doc.path.sub_ext('').to_s }.to_yaml
        end
      end
    end
  end
end