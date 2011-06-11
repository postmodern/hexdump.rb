require 'hexdump/dumper'

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
  # @option options [Integer] :word_size (1)
  #   The number of bytes within a word.
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
  #   The given data does not define the `#each_byte` method,
  #   the `:output` value does not support the `#<<` method or
  #   the `:base` value was unknown.
  #
  def Hexdump.dump(data,options={},&block)
    dumper = Dumper.new(options)
    output = (options.delete(:output) || STDOUT)

    if block
      dumper.each(data,&block)
    else
      dumper.print(data,output)
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
