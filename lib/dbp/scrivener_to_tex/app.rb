require 'dbp/scrivener/project'
require 'open3'
require 'yaml'

module DBP
  module ScrivenerToTex
    class App
      include Open3
      HEADINGS = %w(wtf chapter scene)

      def initialize(options)
        @scrivener_file = options.scrivener_file
        @manuscript_dir = options.output_dir / 'manuscript'
      end

      def run
        scrivener = DBP::Scrivener::Project.new(@scrivener_file)
        write_listing_file(scrivener)
        write_tex_files(scrivener)
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
            '\markdown{---}',
            ''
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
