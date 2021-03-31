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
  # @param [Integer] width (16)
  #   The number of bytes to dump for each line.
  #
  # @param [Integer] endian (:little)
  #   The endianness that the bytes are organized in. Supported endianness
  #   include `:little` and `:big`.
  #
  # @param [Integer] word_size (1)
  #   The number of bytes within a word.
  #
  # @param [Symbol, Integer] base (:hexadecimal)
  #   The base to print bytes in. Supported bases include, `:hexadecimal`,
  #   `:hex`, `16, `:decimal`, `:dec`, `10, `:octal`, `:oct`, `8`,
  #   `:binary`, `:bin` and `2`.
  #
  # @param [Boolean] ascii (false)
  #   Print ascii characters when possible.
  #
  # @param [#<<] output ($stdout)
  #   The output to print the hexdump to.
  #
  # @yield [index,numeric,printable]
  #   The given block will be passed the hexdump break-down of each
  #   segment.
  #
  # @yieldparam [Integer] index
  #   The index of the hexdumped segment.
  #
  # @yieldparam [Array<String>] numeric
  #   The numeric representation of the segment.
  #
  # @yieldparam [Array<String>] printable
  #   The printable representation of the segment.
  #
  # @return [nil]
  #
  # @raise [ArgumentError]
  #   The given data does not define the `#each_byte` method,
  #   the `:output` value does not support the `#<<` method or
  #   the `:base` value was unknown.
  #
  def self.dump(data, output: $stdout, **options,&block)
    dumper = Dumper.new(**options)

    if block then dumper.each(data,&block)
    else          dumper.dump(data,output)
    end

    return nil
  end

  #
  # Hexdumps the object.
  #
  # @see Hexdump.dump
  #
  def hexdump(**options,&block)
    Hexdump.dump(self,**options,&block)
  end
end
