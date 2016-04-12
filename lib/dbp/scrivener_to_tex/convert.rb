require 'rake'
require 'rake/ext/pathname'
require 'yaml'
require 'shell'

module DBP
  module ScrivenerToTex
    class Convert

      def initialize(scrivener)
        @scrivener = scrivener
        @docs = @scrivener.path / 'Files' / 'Docs'
      end

      def write_to(content_dir)
        @scrivener.documents.each { |document| write(content_dir: content_dir, document: document) }
      end

      def write(content_dir:, document:)
        md_path = content_dir / document.path.ext('tex')
        md_path.parent.mkpath

        content = StringIO.new
        content.puts document.header.to_yaml
        content.puts '---'
        rtf_path = rtf_path(document)
        content.puts rtf_to_tex(rtf_path) if rtf_path.file?
        md_path.write(content.string)
      end

      def rtf_to_tex(rtf_path)
        rtf_to_html(rtf_path) | html_to_tex
      end

      def html_to_tex
        Shell.new.system('pandoc', '-f', 'html', '-t', 'latex', '--no-tex-ligatures')
      end

      def rtf_to_html(rtf_path)
        Shell.new.system('textutil', '-convert', 'html', '-excludedelements', '(span)', '-strip', '-stdout', rtf_path.to_s)
      end

      def rtf_path(document)
        (@docs / document.id.to_s).ext('rtf')
      end
    end
  end
end
