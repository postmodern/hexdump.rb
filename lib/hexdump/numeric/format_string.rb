module Hexdump
  module Numeric
    class FormatString

      #
      # Initializes the format string.
      #
      # @param [String] fmt
      #   The format string.
      #
      def initialize(fmt)
        @fmt = fmt
      end

      def %(value)
        sprintf(@fmt,value)
      end

    end
  end
end
