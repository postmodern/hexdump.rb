# frozen_string_literal: true

require 'hexdump/types'
require 'hexdump/reader'
require 'hexdump/numeric'
require 'hexdump/char_map'

module Hexdump
  #
  # Handles the parsing of data and formatting of the hexdump.
  #
  # @since 1.0.0
  #
  # @api semipublic
  #
  class Format

    # Default number of columns
    #
    # @since 1.0.0
    DEFAULT_COLUMNS = 16

    # Numeric bases and their formatting classes.
    BASES = {
      16 => Numeric::Hexadecimal,
      10 => Numeric::Decimal,
      8  => Numeric::Octal,
      2  => Numeric::Binary
    }

    # The word type to decode the byte stream as.
    #
    # @return [Type]
    attr_reader :type

    # The base to dump words as.
    #
    # @return [16, 10, 8, 2]
    attr_reader :base

    # The number of columns per hexdump line.
    #
    # @return [Integer]
    attr_reader :columns

    # The format of the index number.
    #
    # @return [Numeric::Hexadecimal,
    #          Numeric::Decimal,
    #          Numeric::Octal,
    #          Numeric::Binary]
    attr_reader :index

    # Mapping of values to their numeric strings.
    #
    # @return [Numeric::Hexadecimal,
    #          Numeric::Decimal,
    #          Numeric::Octal,
    #          Numeric::Binary]
    attr_reader :numeric

    # Mapping of numeric values to their character strings.
    #
    # @return [CharMap::ASCII, CharMap::UTF8]
    attr_reader :char_map

    #
    # Initializes a hexdump format.
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

      @numeric = BASES.fetch(@base) {
                   raise(ArgumentError,"unsupported base: #{@base.inspect}")
                 }.new(@type)
      @index = @numeric.class.new(TYPES[:uint32])

      case @type
      when Type::Char, Type::UChar
        @numeric = Numeric::CharOrInt.new(@numeric)
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
    # Enumerates each row of values read from the given data.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @yield [index, numeric, chars]
    #   The given block will be passed the hexdump break-down of each
    #   segment.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped segment.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<String>, nil] numeric
    #   The numeric representation of the segment.
    #
    # @yieldparam [Array<String>, nil] chars
    #   The printable representation of the segment.
    #
    # @return [ Enumerator]
    #   If no block is given, an Enumerator will be returned.
    #
    def each_row(data,&block)
      @reader.each(data).each_slice(@columns,&block)
    end

    #
    # Enumerates each row, including an index, of hexdumped data.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Integer] offset
    #   The offset to start the index at.
    #
    # @yield [index, row]
    #   The given block will be passed the hexdump break-down of each
    #   segment.
    #
    # @yieldparam [Integer] index
    #   The index of the hexdumped segment.
    #
    # @yieldparam [Array<Integer>, Array<Float>] row
    #   The row of values.
    #
    # @return [Integer, Enumerator]
    #   If a block is given, then the final number of bytes read is returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_row_with_index(data, offset: 0)
      return enum_for(__method__,data, offset: offset) unless block_given?

      index = offset

      each_row(data) do |row|
        yield index, row

        index += (row.length * @type.size)
      end

      return index
    end

    #
    # Enumerates each non-repeating row of hexdumped data.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @option kwargs [Integer] offset
    #   The offset to start the index at.
    #
    # @yield [index, row]
    #   The given block will be passed the hexdump break-down of each
    #   segment.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped segment.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<Integer>, Array<Float>] row
    #   The numeric representation of the segment.
    #
    # @return [Integer, Enumerator]
    #   If a block is given, the final number of bytes read will be returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_non_repeating_row(data,**kwargs)
      return enum_for(__method__,data,**kwargs) unless block_given?

      previous_row = nil
      repeating = false

      each_row_with_index(data,**kwargs) do |index,row|
        if row == previous_row
          unless repeating
            yield '*'
            repeating = true
          end
        else
          if repeating
            previous_row = nil
            repeating    = false
          end

          yield index, row
          previous_row = row
        end
      end
    end

    #
    # Enumerates each formatted row of hexdumped data.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @option kwargs [Integer] offset
    #   The offset to start the index at.
    #
    # @yield [index, numeric, chars]
    #   The given block will be passed the hexdump break-down of each
    #   segment.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped segment.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<String>, nil] numeric
    #   The numeric representation of the segment.
    #
    # @yieldparam [Array<String>, nil] chars
    #   The printable representation of the segment.
    #
    # @return [String, Enumerator]
    #   If a block is given, the final number of bytes read will be returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_formatted_row(data,**kwargs)
      return enum_for(__method__,data,**kwargs) unless block_given?

      format_numeric = lambda { |value| @numeric % value }
      format_char    = lambda { |value| @char_map[value] }

      # cache the formatted values for 8bit and 16bit values
      if @type.size <= 2
        numeric_cache = Hash.new do |hash,value|
                          hash[value] = format_numeric.call(value)
                        end

        char_cache = if @char_map
                       Hash.new do |hash,value|
                         hash[value] = format_char.call(value)
                       end
                     end
      else
        numeric_cache = format_numeric
        char_cache    = format_char
      end

      index = each_non_repeating_row(data,**kwargs) do |index,row|
        if index == '*'
          yield index
        else
          index   = @index % index
          numeric = Array.new(row.length)
          chars   = Array.new(row.length)

          row.each_with_index do |value,i|
            numeric[i] = numeric_cache[value]
            chars[i]   = char_cache[value] if @char_map
          end

          yield index, numeric, chars
        end
      end

      return @index % index
    end

    #
    # Enumerates over each line in the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @option kwargs [Integer] offset
    #   The offset to start the index at.
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
    def each_line(data,**kwargs)
      return enum_for(__method__,data) unless block_given?

      chars_per_column = @numeric.width
      number_of_spaces = (@columns - 1)
      numeric_width    = ((chars_per_column * @columns) + number_of_spaces)

      index = each_formatted_row(data,**kwargs) do |index,numeric,chars|
        if index == '*'
          yield index
        else
          numeric = numeric.join(' ').ljust(numeric_width)
          line    = if @char_map
                      "#{index}  #{numeric}  |#{chars.join}|#{$/}"
                    else
                      "#{index}  #{numeric}#{$/}"
                    end

          yield line
        end
      end

      yield "#{index}#{$/}"
      return nil
    end

    #
    # Prints the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [#print] output
    #   The output to dump the hexdump to.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments.
    #
    # @option kwargs [Integer] offset
    #   The offset to start the index at.
    #
    # @return [nil]
    #
    # @raise [ArgumentError]
    #   The output value does not support the `#print` method.
    #
    def print(data, output: $stdout, **kwargs)
      unless output.respond_to?(:print)
        raise(ArgumentError,"output must support the #print method")
      end

      each_line(data,**kwargs) do |line|
        output.print(line)
      end
    end

  end
end
