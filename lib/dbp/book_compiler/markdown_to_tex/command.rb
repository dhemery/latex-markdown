module DBP
  module BookCompiler
    module MarkdownToTex
      module Command
        attr_reader :name, :pattern
        alias :eql? :==

        def execute(translator, reader, writer)
          read(reader)
          write(writer, reader)
          transition(translator, reader)
        end

        def read(reader)
          reader.scan(pattern || //)
        end

        def write(_, _)
          ;
        end

        def transition(_, _)
          ;
        end

        def ==(other)
          self.to_s == other.to_s
        end

        def hash
          to_s.hash
        end
      end
    end
  end
end