require 'yaml'
require 'shell'
require 'open3'

module DBP
  module ScrivenerToTex
    class Convert
      include Open3
      HEADINGS = %w(wtf chapter scene)

      def write(content_dir:, document:)
        rtf_path = document.rtf_path
        return unless rtf_path.file?
        tex_path = content_dir / document.path.sub_ext('.tex')
        tex_path.parent.mkpath
        tex_path.open('w') do |tex_file|
          write_header(document.header, tex_file)
          tex_file.puts rtf_to_tex(rtf_path)
        end
      end

      def rtf_to_tex(rtf_path)
        html_to_tex(rtf_to_html(rtf_path))
      end

      def html_to_tex(html)
        tex, _ = capture2('pandoc', '-f', 'html', '-t', 'latex', '--no-tex-ligatures', stdin_data: html)
        tex.gsub /\\ldots\{\}/, '…'
      end

      def rtf_to_html(rtf_path)
        html, _ = capture2('textutil', '-convert', 'html', '-excludedelements', '(span)', '-strip', '-stdout', rtf_path.to_s)
        html
      end

      def write_header(header, file)
        file.puts '\markdown{---}'
        file.puts('\\markdown{guide: start}') if is_start_doc(header)
        file.puts heading(header)
        file.puts '\markdown{---}', ''
      end

      def is_start_doc(header)
        header['position'] == 1 && header['depth'] == 1
      end

      def heading(header)
        "\\#{HEADINGS[header['depth']]}{#{header['title']}}"
      end
    end
  end
end
