require_relative 'document'
require 'nokogiri'
require 'pathname'

module DBP
  module ScrivenerToTex
    class Scrivener
      attr_reader :documents, :path

      def initialize(path)
        @path = Pathname(path)
        basename = path.basename
        scrivx_path = path / basename.sub_ext('.scrivx')
        raise "Cannot read SCRIVX file: #{scrivx_path}" unless scrivx_path.exist?
        scrivx_file = scrivx_path.open
        scrivx = Nokogiri::XML(scrivx_file)

        @metadata_fields = scrivx.xpath('.//CustomMetaDataSettings/MetaDataField').inject({}) do |fields, field|
          fields[field['ID']] = field.content
          fields
        end

        root = OpenStruct.new 'path' => Pathname.new('')
        @documents = []
        gather_documents(documents: @documents, parent_node: scrivx.xpath('.//BinderItem[@ID="0"]'), parent_document: root)
      end

      private

      def gather_documents(documents:, parent_node:, parent_document:)
        parent_node.xpath('./Children/BinderItem').each_with_index do |node, index|
          document = Document.new(node: node, parent_path: parent_document.path, position: index + 1)
          documents << document
          gather_documents(documents: documents, parent_node: node, parent_document: document)
        end
      end
    end
  end
end
