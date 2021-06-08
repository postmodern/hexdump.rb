# frozen_string_literal: true

require 'hexdump/types'
require 'hexdump/reader'
require 'hexdump/numeric/base'
require 'hexdump/numeric/chars'
require 'hexdump/char_map'

module Hexdump
  #
  # Handles the parsing of data and formatting of the hexdump.
  #
  # @since 0.2.0
  #
  # @api semipublic
  #
  class Dumper

    # Default number of columns
    #
    # @since 1.0.0
    DEFAULT_COLUMNS = 16

    # The word type to decode the byte stream as.
    #
    # @return [Type]
    #
    # @since 1.0.0
    attr_reader :type

    # The base to dump words as.
    #
    # @return [16, 10, 8, 2]
    attr_reader :base

    # The number of columns per hexdump line.
    #
    # @return [Integer]
    #
    # @since 1.0.0
    attr_reader :columns

    # Mapping of values to their numeric strings.
    #
    # @return [Hash, Proc]
    #
    # @since 1.0.0
    attr_reader :numeric

    # Mapping of numeric values to their character strings.
    #
    # @return [CharMap::ASCII, CharMap::UTF8]
    #
    # @since 1.0.0
    attr_reader :char_map

    #
    # Creates a new Hexdump dumper.
    #
    # @param [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :longlong, :longlong_le, :longlong_be, :longlong_ne, :ulonglong, :ulonglong_le, :ulonglong_be, :ulonglong_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] type (:byte)
    #   The type to decode the data as.
    #
    # @param [Integer] columns
    #   The number of columns per hexdump line. Defaults to `16 / sizeof(type)`.
    #
    # @param [16, 10, 8, 2] base
    #   The base to print bytes in. Defaults to 16, or to 10 if printing floats.
    #
    # @raise [ArgumentError]
    #   The values for `:base` or `:endian` were unknown.
    #
    # @since 0.2.0
    #
    def initialize(type: :byte, columns: nil, base: nil, **kwargs)
      @type = TYPES.fetch(type) do
                raise(ArgumentError,"unsupported type: #{type.inspect}")
              end

      @columns = columns || (DEFAULT_COLUMNS / @type.size)

      @base = base || case @type
                      when Type::Float, Type::Char, Type::UChar then 10
                      else                                           16
                      end

      @reader = Reader.new(@type)

      @numeric = case @base
                 when 16 then Numeric::Base::Hexadecimal.new(@type)
                 when 10 then Numeric::Base::Decimal.new(@type)
                 when 8  then Numeric::Base::Octal.new(@type)
                 when 2  then Numeric::Base::Binary.new(@type)
                 else
                   raise(ArgumentError,"unsupported base: #{@base.inspect}")
                 end

      case @type
      when Type::Char, Type::UChar
        @numeric = Numeric::Chars.new(@numeric)
      end

      @char_map = case @type
                    when Type::Char, Type::UChar
                      nil # disable the printable characters for chars
                    when Type::UInt8
                      CharMap::ASCII
                    when Type::UInt
                      CharMap::UTF8
                    when Type::Int
                      nil # disable the printable characters for signed ints
                    when Type::Float
                      nil # disable the printable characters for floats
                    end
    end

    #
    # Iterates over the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @yield [index,numeric,characters]
    #   The given block will be passed the hexdump break-down of each
    #   segment.
    #
    # @yieldparam [Integer] index
    #   The index of the hexdumped segment.
    #
    # @yieldparam [Array<String>] numeric
    #   The numeric representation of the segment.
    #
    # @yieldparam [Array<String>] characters
    #   The printable representation of the segment.
    #
    # @return [Integer, Enumerator]
    #   If a block is given, then the final number of bytes read is returned.
    #   If no block is given, an Enumerator will be returned.
    #
    # @since 0.2.0
    #
    def each(data)
      return enum_for(__method__,data) unless block_given?

      count = 0
      index = 0
      slice_size = (@columns * @type.size)

      numeric    = Array.new(@columns)
      characters = Array.new(@columns)

      @reader.each(data) do |word|
        numeric[count]    = @numeric % word
        characters[count] = @char_map[word] if @char_map

        count += 1

        if count >= @columns
          if @char_map
            yield index, numeric, characters
          else
            yield index, numeric
          end

          index += slice_size
          count = 0
        end
      end

      if count > 0
        # yield the remaining data
        if @char_map
          yield index, numeric[0,count], characters[0,count]
        else
          yield index, numeric[0,count]
        end

        index += (count * @type.size)
      end

      return index
    end

    #
    # Enumerates over each line in the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @yield [line]
    #   The given block will be passed each line from the hexdump.
    #
    # @yieldparam [String] line
    #   Each line from the hexdump output, terminated with a newline character.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator object will be returne.d
    #
    # @return [nil]
    #
    # @since 1.0.0
    #
    def each_line(data)
      return enum_for(__method__,data) unless block_given?

      chars_per_column = @numeric.width
      numeric_width = ((chars_per_column * @columns) + (@columns - 1))
      index_format = "%.8x"
      spacer = "  "

      if @char_map
        format_string = "#{index_format}#{spacer}%-#{numeric_width}s#{spacer}|%s|#{$/}"

        index = each(data) do |index,numeric,characters|
          yield sprintf(format_string,index,numeric.join(' '),characters.join)
        end
      else
        format_string = "#{index_format}#{spacer}%-#{numeric_width}s"

        index = each(data) do |index,numeric|
          yield sprintf(format_string,index,numeric.join(' '))
        end
      end

      yield sprintf("#{index_format}#{$/}",index)
      return nil
    end

    #
    # Dumps the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [#<<] output
    #   The output to dump the hexdump to.
    #
    # @return [nil]
    #
    # @raise [ArgumentError]
    #   The output value does not support the `#<<` method.
    #
    # @since 0.2.0
    #
    def dump(data,output=$stdout)
      unless output.respond_to?(:<<)
        raise(ArgumentError,"output must support the #<< method")
      end

      each_line(data) do |line|
        output << line
      end
    end

  end
end
