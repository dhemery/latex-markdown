module DBP::BookCompiler::MarkdownToTex
  class Translator
    def translate(reader, writer)
      reader.scan(/<!--[[:space:]]*(.*?)[[:space:]]*-->/)
      writer.write(reader[1])
    end
  end
end