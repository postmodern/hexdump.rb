module Hexdump
  #
  # Hexdumps the object.
  #
  # @param [#<<] output
  #   The output to print the hexdump to.
  #
  # @yield [index,hex_segment,print_segment]
  #   The given block will be passed the hexdump break-down of each segment.
  #
  # @yieldparam [Integer] index
  #   The index of the hexdumped segment.
  #
  # @yieldparam [Array<String>] hex_segment
  #   The hexadecimal-byte representation of the segment.
  #
  # @yieldparam [Array<String>] print_segment
  #   The print-character representation of the segment.
  #
  # @return [nil]
  #
  def hexdump(output=STDOUT)
    index = 0
    offset = 0
    hex_segment = []
    print_segment = ''

    segment = lambda {
      if block_given?
        yield(index,hex_segment,print_segment)
      else
        output << sprintf(
          "%.8x  %s  |%s|\n",
          index,
          hex_segment.join(' ').ljust(47).insert(23,' '),
          print_segment
        )
      end
    }

    each_byte do |b|
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
