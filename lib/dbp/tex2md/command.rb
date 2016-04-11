module DBP
  module TeX2md
    module Command
      attr_reader :name, :pattern
      alias :eql? :==

      def execute(translator, reader, writer)
        captured = read(reader)
        write(writer, captured)
        transition(translator, captured)
      end

      def read(reader)
        match = reader.scan(pattern || //)
        reader[1] || match
      end

      def write(_, _) ; end

      def transition(_, _) ; end

      def ==(other)
        self.to_s == other.to_s
      end

      def hash
        to_s.hash
      end
    end
  end
end
