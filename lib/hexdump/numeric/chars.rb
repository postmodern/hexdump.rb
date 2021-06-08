require 'hexdump/char_map/ascii'

module Hexdump
  module Numeric
    class Chars

      # Printable characters including escape characters.
      #
      # @since 1.0.0
      ESCAPE_CHARS = {
        0x00 => "\\0",
        0x07 => "\\a",
        0x08 => "\\b",
        0x09 => "\\t",
        0x0a => "\\n",
        0x0b => "\\v",
        0x0c => "\\f",
        0x0d => "\\r"
      }

      # @return [Base::Hexadecimal, Base::Decimal, Base::Octal, Base::Binary]
      attr_reader :base

      #
      # Initializes the character format.
      #
      # @param [Base::Hexadecimal, Base::Decimal, Base::Octal, Base::Binary] base
      #   The numeric base format to fallback to if a value does not map to a
      #   character.
      #
      def initialize(base)
        @base = base
      end

      def width
        @base.width
      end

      #
      # Formats a given ASCII byte value to a character or numeric format.
      #
      # @param [Integer] value
      #   The ASCII byte value.
      #
      # @return [String]
      #   The character or numeric formatted value.
      #
      def %(value)
        if (char = CharMap::ASCII::PRINTABLE[value])
          "  #{char}"
        elsif (char = ESCAPE_CHARS[value])
          " #{char}"
        else
          @base % value
        end
      end

    end
  end
end
