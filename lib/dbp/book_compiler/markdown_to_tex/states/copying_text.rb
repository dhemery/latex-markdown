module DBP::BookCompiler::MarkdownToTex
  class CopyingText
    COPYABLE_TEXT = /[^<*_]*/
    def enter(translator, scanner)
      scanner.scan COPYABLE_TEXT
      translator.write(scanner[0])
      translator.transition_to(:executing_operator)
    end
  end
end