module DBP::BookCompiler::MarkdownToTex
  class CopyingText
    COPYABLE_TEXT = /[^*]*/
    def enter(translator, scanner)
      scanner.scan COPYABLE_TEXT
      translator.write(scanner[0])
      translator.enter(:executing_operator)
    end
  end
end