# frozen_string_literal: true

require 'hexdump/types'
require 'hexdump/reader'
require 'hexdump/numeric'
require 'hexdump/chars'

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

    # The reader object.
    #
    # @return [Reader]
    attr_reader :reader

    # The base to dump words as.
    #
    # @return [16, 10, 8, 2]
    attr_reader :base

    # The number of columns per hexdump line.
    #
    # @return [Integer]
    attr_reader :columns

    # The number of columns to group together.
    #
    # @return [Integer, false]
    attr_reader :group_columns

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

    # The characters formatter.
    #
    # @return [Chars, nil]
    attr_reader :chars

    #
    # Initializes a hexdump format.
    #
    # @param [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :longlong, :longlong_le, :longlong_be, :longlong_ne, :ulonglong, :ulonglong_le, :ulonglong_be, :ulonglong_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] type (:byte)
    #   The type to decode the data as.
    #
    # @param [Integer] columns
    #   The number of columns per hexdump line. Defaults to `16 / sizeof(type)`.
    #
    # @param [Integer, nil] group_columns
    #   Separate groups of columns with an additional space.
    #
    # @param [16, 10, 8, 2] base
    #   The base to print bytes in. Defaults to 16, or to 10 if printing floats.
    #
    # @param [16, 10, 8, 2] index_base
    #   Control the base that the index is displayed in. Defaults to base 16.
    #
    # @param [:ascii, :utf8, Encoding, nil] encoding
    #   The encoding to display the characters in.
    #
    # @param [Boolean] zero_pad
    #   Enables or disables zero padding of data, so that the remaining bytes
    #   can be decoded as a uint, int, or float.
    #
    # @raise [ArgumentError]
    #   The values for `:base` or `:endian` were unknown.
    #
    def initialize(type: :byte, columns: nil, group_columns: nil, repeating: false, base: nil, index_base: 16, chars: true, encoding: nil, zero_pad: false)
      @type = TYPES.fetch(type) do
                raise(ArgumentError,"unsupported type: #{type.inspect}")
              end

      @reader = Reader.new(@type, zero_pad: zero_pad)

      @columns = columns || (DEFAULT_COLUMNS / @type.size)
      @group_columns = group_columns

      @repeating = repeating

      @base = base || case @type
                      when Type::Float, Type::Char, Type::UChar then 10
                      else                                           16
                      end

      @index = BASES.fetch(index_base) {
                 raise(ArgumentError,"unsupported base: #{index_base.inspect}")
               }.new(TYPES[:uint32])

      @numeric = BASES.fetch(@base) {
                   raise(ArgumentError,"unsupported base: #{@base.inspect}")
                 }.new(@type)

      case @type
      when Type::Char, Type::UChar
        @numeric = Numeric::CharOrInt.new(@numeric,@encoding)
        @chars   = nil
      else
        @chars = if chars
                   Chars.new(encoding)
                 end
      end
    end

    #
    # Enumerates over each slice of read values.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @yield [slice]
    #   The given block will be passed the hexdump break-down of each
    #   row.
    #
    # @yieldparam [Array<(String, Integer)>, Array<(String, Float)>] slice
    #   The decoded values.
    #
    # @return [Enumerator]
    #   If no block is given, an Enumerator will be returned.
    #
    def each_slice(data,&block)
      @reader.each(data).each_slice(@columns,&block)
    end

    #
    # Enumerates each row of values read from the given data.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Integer] offset
    #   The offset to start the index at.
    #
    # @yield [index, values, chars]
    #   The given block will be passed the hexdump break-down of each
    #   row.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped row.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<Integer>, Array<Float>] values
    #   The decoded values.
    #
    # @yieldparam [String] chars
    #   A raw characters that were read.
    #
    # @return [Integer, Enumerator]
    #   If a block is given, then the final number of bytes read is returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_row(data, offset: 0, &block)
      return enum_for(__method__,data, offset: offset) unless block_given?

      index = offset

      each_slice(data) do |slice|
        numeric = []
        chars   = []

        next_index = index

        slice.each do |(raw,value)|
          numeric << value
          chars   << raw if @chars

          next_index += raw.length
        end

        if @chars
          yield index, numeric, chars
        else
          yield index, numeric
        end

        index = next_index
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
    # @yield [index, numeric, chars]
    #   The given block will be passed the hexdump break-down of each
    #   row.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped row.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<Integer>, Array<Float>, nil] values
    #   The decoded values.
    #
    # @yieldparam [String, nil] chars
    #   A raw characters that were read.
    #
    # @return [Integer, Enumerator]
    #   If a block is given, the final number of bytes read will be returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_non_repeating_row(data,**kwargs)
      return enum_for(__method__,data,**kwargs) unless block_given?

      previous_row = nil
      repeating = false

      each_row(data,**kwargs) do |index,*row|
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

          yield index, *row
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
    #   row.
    #
    # @yieldparam [Integer, '*'] index
    #   The index of the hexdumped row.
    #   If the index is `'*'`, then it indicates the beginning of repeating
    #   rows of data.
    #
    # @yieldparam [Array<String>, nil] numeric
    #   The numeric representation of the row.
    #
    # @yieldparam [Array<String>, nil] chars
    #   The printable representation of the row.
    #
    # @return [String, Enumerator]
    #   If a block is given, the final number of bytes read will be returned.
    #   If no block is given, an Enumerator will be returned.
    #
    def each_formatted_row(data,**kwargs)
      return enum_for(__method__,data,**kwargs) unless block_given?

      format_numeric = lambda { |value| @numeric % value if value }

      # cache the formatted numbers for 8bit and 16bit values
      numeric_cache = if @type.size <= 2
                        Hash.new do |hash,value|
                          hash[value] = format_numeric.call(value)
                        end
                      else
                        format_numeric
                      end

      enum = if @repeating then each_row(data,**kwargs)
             else               each_non_repeating_row(data,**kwargs)
             end

      index = enum.each do |index,numeric,chars|
        if index == '*'
          yield index
        else
          formatted_index   = @index % index
          formatted_numbers = numeric.map { |value| numeric_cache[value] }

          if @chars
            formatted_chars = @chars % chars.join

            yield formatted_index, formatted_numbers, formatted_chars
          else
            yield formatted_index, formatted_numbers
          end
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
      return enum_for(__method__,data,**kwargs) unless block_given?

      chars_per_column = @numeric.width
      number_of_spaces = (@columns - 1)
      number_of_spaces += ((@columns / @group_columns) - 1) if @group_columns
      numeric_width    = ((chars_per_column * @columns) + number_of_spaces)

      join_columns = if @group_columns
                       lambda { |numeric|
                         numeric.each_slice(@group_columns).map { |numbers|
                           numbers.join(' ')
                         }.join('  ')
                       }
                     else
                       lambda { |numeric| numeric.join(' ') }
                     end

      index = each_formatted_row(data,**kwargs) do |index,numeric,chars|
        if index == '*'
          yield "#{index}#{$/}"
        else
          numeric = join_columns.call(numeric).ljust(numeric_width)
          line    = if @chars
                      "#{index}  #{numeric}  |#{chars}|#{$/}"
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
    def hexdump(data, output: $stdout, **kwargs)
      unless output.respond_to?(:<<)
        raise(ArgumentError,"output must support the #<< method")
      end

      each_line(data,**kwargs) do |line|
        output << line
      end
    end

  end
end
