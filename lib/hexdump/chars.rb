module Hexdump
  #
  # @api private
  #
  # @since 1.0.0
  #
  class Chars

    # The encoding to convert the characters to.
    #
    # @return [Encoding, nil]
    attr_reader :encoding

    #
    # Initializes the chars formatter.
    #
    # @param [Encoding, nil] encoding
    #   The encoding to convert characters to.
    #
    def initialize(encoding=nil)
      @encoding = encoding
    end

    #
    # Formats a string of characters.
    #
    # @param [String] chars
    #   The input string of raw characters.
    #
    # @return [String]
    #   The formatted string of raw characters.
    #
    def scrub(chars)
      if @encoding
        chars.force_encoding(@encoding)
        chars.scrub!('.')
        chars.gsub!(/[^[:print:]]/u,'.')
      else
        chars.tr!("^\x20-\x7e",'.')
      end

      chars
    end

  end
end
