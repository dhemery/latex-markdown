require_relative 'convert'
require 'dbp/scrivener/project'

module DBP
  module ScrivenerToTex
    class App
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
        # Each doc
        # - convert doc RTF content to HTML. Maybe { path:, header:, html: }
        # - convert doc header and doc HTML content to TeX
        # - write TeX file
        converter = DBP::ScrivenerToTex::Convert.new
        scrivener.documents.each { |document| write_tex_file(converter, document) }
      end

      def write_tex_file(converter, document)
        converter.write(content_dir: @manuscript_dir, document: document)
      end

      private

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
