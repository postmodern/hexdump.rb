require 'hexdump/format_string'

module Hexdump
  module Numeric
    #
    # @api private
    #
    # @since 1.0.0
    #
    class CharOrInt < FormatString

      # @return [Hexadecimal, Decimal, Octal, Binary]
      attr_reader :base

      # @return [Encoding, nil]
      attr_reader :encoding

      #
      # Initializes the character format.
      #
      # @param [Hexadecimal, Decimal, Octal, Binary] base
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

      #
      # The string width associated with the numeric base.
      #
      # @return [Integer]
      #
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
        if value == 0x00
          super("\\0")
        elsif value == 0x07
          super("\\a")
        elsif value == 0x08
          super("\\b")
        elsif value == 0x09
          super("\\t")
        elsif value == 0x0a
          super("\\n")
        elsif value == 0x0b
          super("\\v")
        elsif value == 0x0c
          super("\\f")
        elsif value == 0x0d
          super("\\r")
        else
          if @encoding
            if value >= 0x00
              char = value.chr(@encoding) rescue nil

              if char && char =~ /[[:print:]]/
                super(char)
              else
                @base % value
              end
            else
              @base % value
            end
          else
            if (value >= 0x20 && value <= 0x7e)
              super(value.chr)
            else
              @base % value
            end
          end
        end
      end

    end
  end
end
