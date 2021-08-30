require 'hexdump/core_ext/io'

class File

  #
  # Hexdumps the contents of a file.
  #
  # @param [String] path
  #   The path of the file.
  #
  # @param [Hash{Symbol => Object}] kwargs
  #   Additional keyword arguments for {Format#initialize}.
  #
  # @option kwargs [#print] :output ($stdout)
  #   The output to print the hexdump to.
  #
  # @option kwargs [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :long_long, :long_long_le, :long_long_be, :long_long_ne, :ulong_long, :ulong_long_le, :ulong_long_be, :ulong_long_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] :type (:byte)
  #   The type to decode the data as.
  #
  # @option kwargs [Integer, nil] :offset
  #   Controls whether to skip N number of bytes before starting to read data.
  #
  # @option kwargs [Integer, nil] :length
  #   Controls control many bytes to read.
  #
  # @option kwargs [Boolean] :zero_pad (false)
  #   Enables or disables zero padding of data, so that the remaining bytes
  #   can be decoded as a uint, int, or float.
  #
  # @option kwargs [Integer] :columns (16)
  #   The number of bytes to dump for each line.
  #
  # @option kwargs [Integer, nil] :group_columns
  #   Separate groups of columns with an additional space.
  #
  # @option kwargs [Integer, :type, nil] :group_chars
  #   Group chars into columns.
  #   If `:type`, then the chars will be grouped by the `type`'s size.
  #
  # @option kwargs [Boolean] :repeating
  #   Controls whether to omit repeating duplicate rows data with a `*`.
  #
  # @option kwargs [16, 10, 8, 2] :base (16)
  #   The base to print bytes in.
  #
  # @option kwargs [16, 10, 8, 2] :index_base (16)
  #   Control the base that the index is displayed in.
  #
  # @option kwargs [Integer, nil] :index_offset
  #   The offset to start the index at.
  #
  # @option kwargs [Boolean] :chars_column (true)
  #   Controls whether to display the characters column.
  #
  # @option kwargs [:ascii, :utf8, Encoding, nil] :encoding
  #   The encoding to display the characters in.
  #
  # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Symbol,Array<Symbol>}] :style
  #   Enables theming of index, numeric, or chars columns.
  #
  # @option kwargs [Boolean, Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>}}] :highlights
  #   Enables selective highlighting of index, numeric, or chars columns.
  #
  # @yield [hexdump]
  #   If a block is given, it will be passed the newly initialized hexdump
  #   instance.
  #
  # @yieldparam [Hexdump::Hexdump] hexdump
  #   The newly initialized hexdump instance.
  #
  # @see IO#hexdump
  #
  # @example
  #   File.hexdump("/bin/ls")
  #   # 00000000  7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00  |.ELF............|
  #   # ...
  #
  def self.hexdump(path,**kwargs,&block)
    self.open(path,'rb') do |file|
      file.hexdump(**kwargs,&block)
    end
  end

end
