require 'rake'
require 'rake/ext/pathname'

module DBP
  module ScrivenerToTex
    class Listing
      def initialize(scrivener)
        @scrivener = scrivener
      end

      def write_to(listing_file)
        dir = listing_file.dirname
        dir.mkpath
        listing_file.open('w') do |f|
          f.puts(@scrivener.documents.map { |doc| doc.path.pathmap('- %X') })
        end
      end
    end
  end
end