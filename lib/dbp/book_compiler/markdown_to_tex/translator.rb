module DBP::BookCompiler::MarkdownToTex
  class Translator
    MARKDOWN_COMMENT = /<!--[[:space:]]*(.*?)[[:space:]]*-->/

    def translate(reader, writer)
      reader.scan(MARKDOWN_COMMENT)
      writer.write(reader[1])
    end
  end
end