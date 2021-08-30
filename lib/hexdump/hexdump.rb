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

    # The reader object.
    #
    # @return [Reader]
    attr_reader :reader

    # The format of the index number.
    #
    # @return [Numeric::Hexadecimal,
    #          Numeric::Decimal,
    #          Numeric::Octal,
    #          Numeric::Binary]
    attr_reader :index

    # The numeric base format.
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
    # @param [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :long_long, :long_long_le, :long_long_be, :long_long_ne, :ulong_long, :ulong_long_le, :ulong_long_be, :ulong_long_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] type (:byte)
    #   The type to decode the data as.
    #
    # @param [Integer, nil] offset
    #   Controls whether to skip N number of bytes before starting to read data.
    #
    # @param [Integer, nil] length
    #   Controls control many bytes to read.
    #
    # @param [Boolean] zero_pad
    #   Enables or disables zero padding of data, so that the remaining bytes
    #   can be decoded as a uint, int, or float.
    #
    # @param [Boolean] repeating
    #   Controls whether to omit repeating duplicate rows data with a `*`.
    #
    # @param [Integer] columns
    #   The number of columns per hexdump line. Defaults to `16 / sizeof(type)`.
    #
    # @param [Integer, nil] group_columns
    #   Separate groups of columns with an additional space.
    #
    # @param [Integer, :type, nil] group_chars
    #   Group chars into columns.
    #   If `:type`, then the chars will be grouped by the `type`'s size.
    #
    # @param [16, 10, 8, 2] base
    #   The base to print bytes in. Defaults to 16, or to 10 if printing floats.
    #
    # @param [16, 10, 8, 2] index_base
    #   Control the base that the index is displayed in. Defaults to base 16.
    #
    # @param [Integer] index_offset
    #   The offset to start the index at.
    #
    # @param [Boolean] chars
    #   Controls whether to display the characters column.
    #
    # @param [:ascii, :utf8, Encoding, nil] encoding
    #   The encoding to display the characters in.
    #
    # @param [Boolean, Hash{:index,:numeric,:chars => Symbol,Array<Symbol>}] style
    #   Enables theming of index, numeric, or chars columns.
    #
    # @param [Boolean, Hash{:index,:numeric,:chars => Hash{String,Regexp => Symbol,Array<Symbol>}}] highlights
    #   Enables selective highlighting of index, numeric, or chars columns.
    #
    # @yield [self]
    #   If a block is given, it will be passed the newly initialized hexdump
    #   instance.
    #
    # @raise [ArgumentError]
    #   The values for `:base` or `:endian` were unknown.
    #
    # @example Initializing styling:
    #   Hexdump::Hexdump.new(style: {index: :white, numeric: :green, chars: :cyan})
    #
    # @example Initializing highlighting:
    #   Hexdump::Hexdump.new(
    #     highlights: {
    #       index: {/00$/ => [:white, :bold]},
    #       numeric: {
    #         /^[8-f][0-9a-f]$/ => :faint,
    #         /f/  => :cyan,
    #         '00' => [:black, :on_red]
    #       },
    #       chars: {/[^\.]+/ => :green}
    #     }
    #   )
    #
    # @example Initializing with a block:
    #   Hexdump::Hexdump.new do |hexdump|
    #     hexdump.type = :uint16
    #     # ...
    #   
    #     hexdump.theme do |theme|
    #       theme.index.highlight(/00$/, [:white, :bold])
    #       theme.numeric.highlight(/^[8-f][0-9a-f]$/, :faint)
    #       # ...
    #     end
    #   end
    #
    def initialize(type: :byte, offset: nil, length: nil, zero_pad: false, repeating: false, columns: nil, group_columns: nil, group_chars: nil, base: nil, index_base: 16, index_offset: nil, chars_column: true, encoding: nil, style: nil, highlights: nil)
      # reader options
      self.type      = type
      self.offset    = offset
      self.length    = length
      self.zero_pad  = zero_pad
      self.repeating = repeating

      # numeric formatting options
      self.base          = base if base
      self.columns       = columns
      self.group_columns = group_columns

      # index options
      self.index_base   = index_base
      self.index_offset = index_offset || offset

      # chars formatting options
      self.encoding     = encoding
      self.chars_column = chars_column
      self.group_chars  = group_chars

      @theme = if (style.kind_of?(Hash) || highlights.kind_of?(Hash))
                 Theme.new(
                   style:      style || {},
                   highlights: highlights || {}
                 )
               end

      yield self if block_given?

      @reader = Reader.new(@type, offset:   @offset,
                                  length:   @length,
                                  zero_pad: @zero_pad)

      # default the numeric base
      @base ||= case @type
                when Type::Float, Type::Char, Type::UChar then 10
                else                                           16
                end

      # default the number of columns based on the type's size
      @columns ||= (DEFAULT_COLUMNS / @type.size)

      @index   = BASES.fetch(@index_base).new(TYPES[:uint32])
      @numeric = BASES.fetch(@base).new(@type)

      case @type
      when Type::Char, Type::UChar
        # display characters inline for the :char and :uchar type, and disable
        # the characters column
        @numeric = Numeric::CharOrInt.new(@numeric,@encoding)

        @chars        = nil
        @chars_column = false
      else
        @chars = Chars.new(@encoding) if @chars_column
      end
    end

    #
    # @group Reader Configuration
    #

    # The word type to decode the byte stream as.
    #
    # @return [Type]
    #
    # @api public
    attr_reader :type

    # The optional offset to start the index at.
    #
    # @return [Integer, nil]
    #
    # @api public
    attr_accessor :offset

    # The optional length of data to read.
    #
    # @return [Integer, nil]
    #
    # @api public
    attr_accessor :length

    # Controls whether to zero-pad the data so it aligns with the type's size.
    #
    # @return [Boolean]
    #
    # @api public
    attr_accessor :zero_pad

    alias zero_pad? zero_pad

    # Controls whether repeating duplicate rows will be omitted with a `*`.
    #
    # @return [Boolean]
    #
    # @api public
    attr_accessor :repeating

    alias repeating? repeating

    #
    # Sets the hexdump type.
    #
    # @param [:int8, :uint8, :char, :uchar, :byte, :int16, :int16_le, :int16_be, :int16_ne, :uint16, :uint16_le, :uint16_be, :uint16_ne, :short, :short_le, :short_be, :short_ne, :ushort, :ushort_le, :ushort_be, :ushort_ne, :int32, :int32_le, :int32_be, :int32_ne, :uint32, :uint32_le, :uint32_be, :uint32_ne, :int, :long, :long_le, :long_be, :long_ne, :uint, :ulong, :ulong_le, :ulong_be, :ulong_ne, :int64, :int64_le, :int64_be, :int64_ne, :uint64, :uint64_le, :uint64_be, :uint64_ne, :long_long, :long_long_le, :long_long_be, :long_long_ne, :ulong_long, :ulong_long_le, :ulong_long_be, :ulong_long_ne, :float, :float_le, :float_be, :float_ne, :double, :double_le, :double_be, :double_ne] value
    #
    # @return [Type]
    #
    # @raise [ArgumentError]
    #
    # @api public
    #
    def type=(value)
      @type = TYPES.fetch(value) do
                raise(ArgumentError,"unsupported type: #{value.inspect}")
              end
    end

    #
    # @group Numeric Configuration
    #

    # The base to dump words as.
    #
    # @return [16, 10, 8, 2]
    #
    # @api public
    attr_accessor :base

    #
    # Sets the numeric column base.
    #
    # @param [16, 10, 8, 2] value
    # 
    # @return [16, 10, 8, 2]
    #
    # @raise [ArgumentError]
    #
    # @api public
    #
    def base=(value)
      case value
      when 16, 10, 8, 2
        @base = value
      else
        raise(ArgumentError,"unsupported base: #{value.inspect}")
      end
    end

    # The number of columns per hexdump line.
    #
    # @return [Integer]
    #
    # @api public
    attr_accessor :columns

    # The number of columns to group together.
    #
    # @return [Integer, nil]
    #
    # @api public
    attr_accessor :group_columns

    #
    # @group Index Configuration
    #

    # The base to format the index column as.
    #
    # @return [16, 10, 8, 2]
    #
    # @api public
    attr_reader :index_base

    #
    # Sets the index column base.
    #
    # @param [16, 10, 8, 2] value
    # 
    # @return [16, 10, 8, 2]
    #
    # @raise [ArgumentError]
    #
    # @api public
    #
    def index_base=(value)
      case value
      when 16, 10, 8, 2
        @index_base = value
      else
        raise(ArgumentError,"unsupported index base: #{value.inspect}")
      end
    end

    # Starts the index at the given offset.
    #
    # @return [Integer, nil]
    #
    # @api public
    attr_accessor :index_offset

    #
    # @group Characters Configuration
    #

    # The encoding to use when decoding characters.
    #
    # @return [Encoding, nil]
    #
    # @api public
    attr_reader :encoding

    #
    # Sets the encoding.
    #
    # @param [:ascii, :utf8, Encoding, nil] value
    #
    # @return [Encoding, nil]
    #
    # @api public
    #
    def encoding=(value)
      @encoding = case value
                  when :ascii   then nil
                  when :utf8    then Encoding::UTF_8
                  when Encoding then value
                  when nil      then nil
                  else
                    raise(ArgumentError,"encoding must be nil, :ascii, :utf8, or an Encoding object")
                  end
    end

    # Controls whether to display the characters column.
    #
    # @return [Boolean]
    #
    # @api public
    attr_accessor :chars_column

    alias chars_column? chars_column

    # Groups the characters together into groups.
    #
    # @return [Integer, nil]
    #
    # @api public
    attr_reader :group_chars

    #
    # Sets the character grouping.
    #
    # @param [Integer, :type] value
    #
    # @return [Integer, nil]
    #
    # @api public
    #
    def group_chars=(value)
      @group_chars = case value
                     when Integer then value
                     when :type   then @type.size
                     when nil     then nil
                     else
                       raise(ArgumentError,"invalid group_chars value: #{value.inspect}")
                     end
    end

    #
    # @group Theme Configuration
    #

    #
    # Determines if hexdump styling/highlighting has been enabled.
    #
    # @return [Boolean]
    #
    # @api public
    #
    def theme?
      !@theme.nil?
    end

    #
    # The hexdump theme.
    #
    # @yield [theme]
    #   If a block is given, the theme will be auto-initialized and yielded.
    #
    # @yieldparam [Theme] theme
    #   The hexdump theme.
    #
    # @return [Theme, nil]
    #   The initialized hexdump theme.
    #
    # @api public
    #
    def theme(&block)
      if block
        @theme ||= Theme.new
        @theme.tap(&block)
      else
        @theme
      end
    end

    #
    # @group Formatting Methods
    #

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

      index = @index_offset || 0
      chars = nil

      each_slice(data) do |slice|
        numeric = []
        chars   = [] if @chars

        next_index = index

        slice.each do |(raw,value)|
          numeric << value
          chars   << raw if @chars

          next_index += raw.length
        end

        yield index, numeric, chars
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
      is_repeating = false

      each_row(data) do |index,*row|
        if row == previous_row
          unless is_repeating
            yield '*'
            is_repeating = true
          end
        else
          if is_repeating
            previous_row = nil
            is_repeating = false
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
        formatted = @index % index
        formatted = @theme.index.apply(formatted) if ansi
        formatted
      }

      blank = ' ' * @numeric.width

      format_numeric = lambda { |value|
        if value
          formatted = @numeric % value
          formatted = @theme.numeric.apply(formatted) if ansi
          formatted
        else
          blank
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

      if @chars
        format_chars = lambda { |chars|
          formatted = @chars.scrub(chars.join)
          formatted = @theme.chars.apply(formatted) if ansi
          formatted
        }
      end

      enum = if @repeating then each_row(data)
             else               each_non_repeating_row(data)
             end

      index = enum.each do |index,numeric,chars=nil|
        if index == '*'
          yield index
        else
          formatted_index   = format_index[index]
          formatted_numbers = numeric.map { |value| numeric_cache[value] }

          formatted_chars = if @chars
                              if @group_chars
                                chars.join.chars.each_slice(@group_chars).map(&format_chars)
                              else
                                format_chars.call(chars)
                              end
                            end

          yield formatted_index, formatted_numbers, formatted_chars
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
    #   If no block is given, an Enumerator object will be returned
    #
    # @return [nil]
    #
    def each_line(data,**kwargs)
      return enum_for(__method__,data,**kwargs) unless block_given?

      join_numeric = if @group_columns
                       lambda { |numeric|
                         numeric.each_slice(@group_columns).map { |numbers|
                           numbers.join(' ')
                         }.join('  ')
                       }
                     else
                       lambda { |numeric| numeric.join(' ') }
                     end

      index = each_formatted_row(data,**kwargs) do |index,numeric,chars=nil|
        if index == '*'
          yield "#{index}#{$/}"
        else
          numeric_column = join_numeric.call(numeric)

          if numeric.length < @columns
            missing_columns = (@columns - numeric.length)
            column_width    = @numeric.width + 1

            spaces = (missing_columns * column_width)
            spaces += ((missing_columns / @group_columns) - 1) if @group_columns

            numeric_column << ' ' * spaces
          end

          line = if @chars
                   if @group_chars
                     chars = chars.join('|')
                   end

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
    #   The output value does not support the `#<<` method.
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
    #   and that String can grow quite large and consume a lot of memory.
    #
    def dump(data)
      String.new.tap do |string|
        hexdump(data, output: string)
      end
    end

  end
end
