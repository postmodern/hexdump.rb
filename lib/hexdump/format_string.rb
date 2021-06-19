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

  end
end
