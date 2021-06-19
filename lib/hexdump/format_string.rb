module Hexdump
  #
  # @api private
  #
  # @since 1.0.0
  #
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

    #
    # Formats the given value.
    #
    # @param [Integer, Float]
    #   The given value.
    #
    # @return [String]
    #   The formatted value.
    #
    def %(*values)
      sprintf(@fmt,*values)
    end

    #
    # Converts the format string back into a String.
    #
    # @return [String]
    #   The raw format string.
    #
    def to_s
      @fmt
    end

  end
end
