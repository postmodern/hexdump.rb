#
# Provides the {Hexdump.dump} method and can add hexdumping to other classes
# by including the {Hexdump} module.
#
#     class AbstractData
#     
#       include Hexdump
#       
#       def each_byte
#         # ...
#       end
#     
#     end
#     
#     data = AbstractData.new
#     data.hexdump
#
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
  # @raise [ArgumentError]
  #   The given data does not define the `#each_byte` method, or
  #   the `:output` value does not support the `#<<` method.
  #
  def Hexdump.dump(data,options={})
    unless data.respond_to?(:each_byte)
      raise(ArgumentError,"the data to hexdump must define #each_byte")
    end

    output = options.fetch(:output,STDOUT)

    unless output.respond_to?(:<<)
      raise(ArgumentError,":output must support the #<< method")
    end

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

    hex_segment_width = ((width * byte_width) + (width - 1))
    line_format = "%.8x  %-#{hex_segment_width}s  |%s|\n"
    index = 0

    data.each_byte.each_slice(width) do |bytes|
      hex_segment = bytes.map(&hex_byte)
      print_segment = bytes.map(&print_byte)

      if block_given?
        yield(index,hex_segment,print_segment)
      else
        output << sprintf(
          line_format,
          index,
          hex_segment.join(' '),
          print_segment.join
        )
      end

      index += width
    end

    return nil
  end

  #
  # Hexdumps the object.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @see Hexdump.dump
  #
  def hexdump(options={},&block)
    Hexdump.dump(self,options,&block)
  end
end
