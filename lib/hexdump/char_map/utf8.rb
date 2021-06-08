require 'hexdump/char_map/ascii'

module Hexdump
  module CharMap
    module UTF8
      include ASCII

      #
      # Formats the given integer value into a UTF8 character.
      #
      # @param [Integer] value
      #   The integer value.
      #
      # @return [String, UNPRINTABLE]
      #   The UTF8 character, or {ASCII::UNPRINTABLE} if the integer value
      #   does not map to a valid UTF8 character.
      #
      def self.[](value)
        if (value >= 0x00 && value <= 0xff)
          ASCII[value]
        else
          PRINTABLE.fetch(value) do
            # XXX: https://github.com/jruby/jruby/issues/6652
            char = value.chr(Encoding::UTF_8) rescue nil
            char || UNPRINTABLE
          end
        end
      end
    end
  end
end
