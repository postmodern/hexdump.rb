module Hexdump
  #
  # Hexdumps an object.
  #
  # @param [#<<] output
  #   The output stream to print the hexdump to.
  #
  # @yield [line]
  #   The given block will be passed each line of the hexdump.
  #
  # @yieldparam [String] line
  #   A line of the hexdump.
  #
  # @return [nil]
  #
  def hexdump(output=STDOUT)
    index = 0
    offset = 0
    hex_segment = []
    print_segment = ''

    segment = lambda {
      line = sprintf(
        "%.8x  %s  |%s|\n",
        index,
        hex_segment.join(' ').ljust(47).insert(23,' '),
        print_segment
    )

    if block_given?
      yield line
    else
      output << line
    end
    }

    object.each_byte do |b|
      if offset == 0
        hex_segment.clear
        print_segment.clear
      end

      hex_segment << ("%.2x" % b)

      print_segment << case b
      when (0x20..0x7e)
        b.chr
      else
        '.'
      end

      offset += 1

      if (offset >= 16)
        segment.call

        offset = 0
        index += 16
      end
    end

    # flush the hexdump buffer
    segment.call unless offset == 0
    return nil
  end
end
