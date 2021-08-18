# frozen_string_literal: true

require 'hexdump/types'
require 'hexdump/reader'
require 'hexdump/numeric'
require 'hexdump/chars'
require 'hexdump/theme'

module Hexdump
  #
  # Handles the parsing of data and formatting of the hexdump.
  #
  # @since 1.0.0
  #
  # @api semipublic
  #
  class Hexdump

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

    # The optional offset to start the index at.
    #
    # @return [Integer]
    attr_reader :offset

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

    # Theme for the hexdump.
    #
    # @return [Theme, nil]
    attr_reader :theme

    #
    # Initializes a hexdump format.
    #
    # @param [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :longlong, :longlong_le, :longlong_be, :longlong_ne, :ulonglong, :ulonglong_le, :ulonglong_be, :ulonglong_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] type (:byte)
    #   The type to decode the data as.
    #
    # @param [Integer, nil] skip
    #   Controls whether to skip N number of bytes before starting to read data.
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
    # @param [Integer] offset
    #   The offset to start the index at.
    #
    # @param [:ascii, :utf8, Encoding, nil] encoding
    #   The encoding to display the characters in.
    #
    # @param [Boolean] zero_pad
    #   Enables or disables zero padding of data, so that the remaining bytes
    #   can be decoded as a uint, int, or float.
    #
    # @param [Boolean, Hash{:index,:numeric,:chars => Symbol,Array<Symbol>}] theme
    #   Enables theming of index, numeric, or chars columns.
    #
    # @param [Boolean, Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>}}] highlights
    #   Enables selective highlighting of index, numeric, or chars columns.
    #
    # @raise [ArgumentError]
    #   The values for `:base` or `:endian` were unknown.
    #
    def initialize(type: :byte, skip: nil, columns: nil, group_columns: nil, repeating: false, base: nil, index_base: 16, offset: 0, chars: true, encoding: nil, zero_pad: false, theme: nil, style: nil, highlights: nil)
      @type = TYPES.fetch(type) do
                raise(ArgumentError,"unsupported type: #{type.inspect}")
              end

      @reader = Reader.new(@type, skip: skip, zero_pad: zero_pad)

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

      @offset = offset

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

      @theme = if (style.kind_of?(Hash) || highlights.kind_of?(Hash))
                 Theme.new(
                   style:      style || {},
                   highlights: highlights || {}
                 )
               elsif theme
                 Theme.new
               end
    end

    #
    # Determines if hexdump styling/highlighting has been enabled.
    #
    # @return [Boolean]
    #
    def theme?
      !@theme.nil?
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
    def each_row(data,&block)
      return enum_for(__method__,data) unless block_given?

      index = @offset

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
    def each_non_repeating_row(data)
      return enum_for(__method__,data) unless block_given?

      previous_row = nil
      repeating = false

      each_row(data) do |index,*row|
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
    # @param [Boolean] ansi
    #   Whether to enable styling/highlighting.
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
    def each_formatted_row(data, ansi: theme?, **kwargs)
      return enum_for(__method__,data, ansi: ansi) unless block_given?

      format_index = lambda { |index|
        formatted_index = @index % index
        formatted_index = @theme.index.apply(formatted_index) if ansi
        formatted_index
      }

      format_numeric = lambda { |value|
        if value
          formatted_value = @numeric % value
          formatted_value = @theme.numeric.apply(formatted_value) if ansi
          formatted_value
        end
      }

      # cache the formatted numbers for 8bit and 16bit values
      numeric_cache = if @type.size <= 2
                        Hash.new do |hash,value|
                          hash[value] = format_numeric.call(value)
                        end
                      else
                        format_numeric
                      end

      enum = if @repeating then each_row(data)
             else               each_non_repeating_row(data)
             end

      index = enum.each do |index,numeric,chars|
        if index == '*'
          yield index
        else
          formatted_index   = format_index[index]
          formatted_numbers = numeric.map { |value| numeric_cache[value] }

          if @chars
            formatted_chars = @chars % chars.join
            formatted_chars = @theme.chars.apply(formatted_chars) if ansi

            yield formatted_index, formatted_numbers, formatted_chars
          else
            yield formatted_index, formatted_numbers
          end
        end
      end

      return format_index[index]
    end

    #
    # Enumerates over each line in the hexdump.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @param [Hash{Symbol => Object}] kwargs
    #   Additional keyword arguments for {#each_formatted_row}.
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
          numeric_column = join_columns.call(numeric)

          if numeric.length < @columns
            missing_columns = (@columns - numeric.length)
            column_width    = @numeric.width + 1

            spaces = (missing_columns * column_width)
            spaces += ((missing_columns / @group_columns) - 1) if @group_columns

            numeric_column << ' ' * spaces
          end

          line    = if @chars
                      "#{index}  #{numeric_column}  |#{chars}|#{$/}"
                    else
                      "#{index}  #{numeric_column}#{$/}"
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
    # @return [nil]
    #
    # @raise [ArgumentError]
    #   The output value does not support the `#print` method.
    #
    def hexdump(data, output: $stdout)
      unless output.respond_to?(:<<)
        raise(ArgumentError,"output must support the #<< method")
      end

      ansi = theme? && $stdout.tty?

      each_line(data, ansi: ansi) do |line|
        output << line
      end
    end

    #
    # Outputs the hexdump to a String.
    #
    # @param [#each_byte] data
    #   The data to be hexdumped.
    #
    # @return [String]
    #   The output of the hexdump.
    #
    # @note
    #   **Caution:** this method appends each line of the hexdump to a String,
    #   that String can grow quite large and consume a lot of memory.
    #
    def dump(data)
      String.new.tap do |string|
        hexdump(data, output: string)
      end
    end

  end
end
