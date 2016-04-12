module DBP
  module ScrivenerToTex
    class Document
      attr_reader :id, :path

      def initialize(node:, parent_path:, position:)
        @id = node['ID'].to_i
        @title = node.at_xpath('./Title').content
        @type = node['Type']
        slug = @title.gsub(/\s+/, '-').gsub(/[^[:alnum:]-]/, '').downcase
        @path = parent_path / slug
        @custom_metadata = custom_metadata(node)
        @position = position
      end

      def header
        {
            'id' => @id,
            'title' => @title,
            'type' => @type,
            'depth' => @path.to_s.split('/').size,
            'position' => @position
        }.merge(@custom_metadata)
      end

      private

      def custom_metadata(node)
        node.xpath('./MetaData/CustomMetaData/MetaDataItem').inject({}) do |fields, field|
          id = field.at_xpath('./FieldID').content
          value = field.at_xpath('./Value').content
          fields[id] = value
          fields
        end
      end
    end
  end
end
