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
    # @param [:ascii, :utf8, Encoding, nil] encoding
    #   The encoding to convert characters to.
    #
    # @raise [ArgumentError]
    #   An invalid encoding was given.
    #
    def initialize(encoding=nil)
      @encoding = case encoding
                  when :ascii   then nil
                  when :utf8    then Encoding::UTF_8
                  when Encoding then encoding
                  when nil      then nil
                  else
                    raise(ArgumentError,"encoding must be nil, :ascii, :utf8, or an Encoding object")
                  end
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
    def %(chars)
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
