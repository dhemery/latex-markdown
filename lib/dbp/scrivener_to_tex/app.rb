require_relative 'convert'
require_relative 'listing'
require_relative 'scrivener'

module DBP
  module ScrivenerToTex
    class App
      def initialize(options)
        @scrivener_file = options.scrivener_file
        @manuscript_dir = options.output_dir / 'manuscript'
        @listing_file = @manuscript_dir / 'listing.yaml'
      end

      def run
        scrivener = DBP::ScrivenerToTex::Scrivener.new(@scrivener_file)
        DBP::ScrivenerToTex::Listing.new(scrivener).write_to(@listing_file)
        DBP::ScrivenerToTex::Convert.new(scrivener).write_to(@manuscript_dir)
      end
    end
  end
end
