module Hexdump
  #
  # Hexdumps the given data.
  #
  # @param [#each_byte] data
  #   The data to be hexdumped.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Integer] :width (16)
  #   The number of bytes to dump for each line.
  #
  # @option options [Symbol, Integer] :base (:hexadecimal)
  #   The base to print bytes in. Supported bases include, `:hexadecimal`,
  #   `:hex`, `16, `:decimal`, `:dec`, `10, `:octal`, `:oct`, `8`,
  #   `:binary`, `:bin` and `2`.
  #
  # @option options [Boolean] :ascii (false)
  #   Print ascii characters when possible.
  #
  # @option options [#<<] :output (STDOUT)
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
  def Hexdump.dump(data,options={})
    output = options.fetch(:output,STDOUT)
    width = options.fetch(:width,16)
    base = options.fetch(:base,:hexadecimal)
    ascii = options.fetch(:ascii,false)
    byte_width, byte_format = case base
                              when :hexadecimal, :hex, 16
                                [2, "%.2x"]
                              when :decimal, :dec, 10
                                [3, "%3.d"]
                              when :octal, :oct, 8
                                [4, "0%.3o"]
                              when :binary, :bin, 2
                                [8, "%.8b"]
                              end

    index = 0
    hex_segment = []
    print_segment = []

    hex_byte = lambda { |byte|
      if (ascii && (byte >= 0x20 && byte <= 0x7e))
        byte.chr
      else
        byte_format % byte
      end
    }

    print_byte = lambda { |byte|
      if (byte >= 0x20 && byte <= 0x7e)
        byte.chr
      else
        '.'
      end
    }

    segment_width = ((width * byte_width) + (width - 1))
    segment_format = "%.8x  %-#{segment_width}s  |%s|\n"
    segment = if block_given?
                lambda { yield(index,hex_segment,print_segment) }
              else
                lambda {
                  output << sprintf(
                    segment_format,
                    index,
                    hex_segment.join(' '),
                    print_segment.join
                  )
                }
              end

    data.each_byte.each_slice(width) do |bytes|
      hex_segment.clear
      print_segment.clear

      bytes.each do |b|
        hex_segment << hex_byte[b]
        print_segment << print_byte[b]
      end

      segment.call
      index += width
    end

    # flush the hexdump buffer
    return nil
  end

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
  # @see Hexdump.dump
  #
  def hexdump(output=STDOUT,&block)
    Hexdump.dump(self,output,&block)
  end
end
