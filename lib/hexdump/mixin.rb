require 'hexdump/hexdump'

module Hexdump
  #
  # Provides a {hexdump Mixin#hexdump} method that can be included into objects.
  #
  #     class DataObject
  #     
  #       include Hexdump::Mixin
  #       
  #       def each_byte
  #         # ...
  #       end
  #     
  #     end
  #     
  #     data.hexdump
  #
  # @api public
  #
  # @since 1.0.0
  #
  module Mixin
    #
    # Prints a hexdumps of the object.
    #
    # @param [#print] output ($stdout)
    #   The output to print the hexdump to.
    #
    # @param [Integer] offset
    #   The offset to start the index at.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {Hexdump#initialize}.
    #
    # @option kwargs [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :longlong, :longlong_le, :longlong_be, :longlong_ne, :ulonglong, :ulonglong_le, :ulonglong_be, :ulonglong_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] :type (:byte)
    #   The type to decode the data as.
    #
    # @option kwargs [Integer, nil] :skip
    #   Controls whether to skip N number of bytes before starting to read data.
    #
    # @option kwargs [Integer] :columns (16)
    #   The number of bytes to dump for each line.
    #
    # @option kwargs [16, 10, 8, 2] :base (16)
    #   The base to print bytes in.
    #
    # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Symbol,Array<Symbol>}] :style
    #   Enables theming of index, numeric, or chars columns.
    #
    # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>}}] :highlights
    #   Enables selective highlighting of index, numeric, or chars columns.
    #
    # @raise [ArgumentError]
    #   The given data does not define the `#each_byte` method,
    #   the `:output` value does not support the `#<<` method or
    #   the `:base` value was unknown.
    #
    def hexdump(output: $stdout, **kwargs)
      hexdump = ::Hexdump::Hexdump.new(**kwargs)

      hexdump.hexdump(self, output: output)
    end

    #
    # Outputs the hexdump to a String.
    #
    # @param [Integer] offset
    #   The offset to start the index at.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {Hexdump#initialize}.
    #
    # @option kwargs [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :longlong, :longlong_le, :longlong_be, :longlong_ne, :ulonglong, :ulonglong_le, :ulonglong_be, :ulonglong_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] :type (:byte)
    #   The type to decode the data as.
    #
    # @option kwargs [Integer, nil] :skip
    #   Controls whether to skip N number of bytes before starting to read data.
    #
    # @option kwargs [Integer, nil] :limit
    #   Controls control many bytes to read.
    #
    # @option kwargs [Integer] :columns (16)
    #   The number of bytes to dump for each line.
    #
    # @option kwargs [16, 10, 8, 2] :base (16)
    #   The base to print bytes in.
    #
    # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Symbol,Array<Symbol>}] :style
    #   Enables theming of index, numeric, or chars columns.
    #
    # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>}}] :highlights
    #   Enables selective highlighting of index, numeric, or chars columns.
    #
    # @return [String]
    #   The output of the hexdump.
    #
    # @raise [ArgumentError]
    #   The given data does not define the `#each_byte` method,
    #   the `:base` value was unknown.
    #
    # @note
    #   **Caution:** this method appends each line of the hexdump to a String,
    #   that String can grow quite large and consume a lot of memory.
    #
    def to_hexdump(**kwargs)
      hexdump = ::Hexdump::Hexdump.new(**kwargs)

      hexdump.dump(self)
    end
  end
end
