require 'hexdump/format_string'

module Hexdump
  module Numeric
    #
    # @api private
    #
    # @since 1.0.0
    #
    class CharOrInt < FormatString

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

      # @return [Encoding, nil]
      attr_reader :encoding

      #
      # Initializes the character format.
      #
      # @param [Base::Hexadecimal, Base::Decimal, Base::Octal, Base::Binary] base
      #   The numeric base format to fallback to if a value does not map to a
      #   character.
      #
      # @param [Encoding, nil] encoding
      #   The optional encoding to convert bytes to.
      #
      def initialize(base,encoding=nil)
        @base     = base
        @encoding = encoding
        
        super("%#{@base.width}s")
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
        if @encoding
          if value >= 0x00
            ESCAPE_CHARS.fetch(value) do
              char = value.chr(@encoding) rescue nil

              if char && char =~ /[[:print:]]/
                super(char)
              else
                @base % value
              end
            end
          else
            @base % value
          end
        else
          if (value >= 0x20 && value <= 0x7e)
            super(value.chr)
          elsif (char = ESCAPE_CHARS[value])
            super(char)
          else
            @base % value
          end
        end
      end

    end
  end
end
