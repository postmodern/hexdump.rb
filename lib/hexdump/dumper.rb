# frozen_string_literal: true

require 'hexdump/types'
require 'hexdump/reader'

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

    # Character to represent unprintable characters
    UNPRINTABLE = '.'

    # ASCII printable bytes and characters
    PRINTABLE = {
      0x20 => " ",
      0x21 => "!",
      0x22 => "\"",
      0x23 => "#",
      0x24 => "$",
      0x25 => "%",
      0x26 => "&",
      0x27 => "'",
      0x28 => "(",
      0x29 => ")",
      0x2a => "*",
      0x2b => "+",
      0x2c => ",",
      0x2d => "-",
      0x2e => ".",
      0x2f => "/",
      0x30 => "0",
      0x31 => "1",
      0x32 => "2",
      0x33 => "3",
      0x34 => "4",
      0x35 => "5",
      0x36 => "6",
      0x37 => "7",
      0x38 => "8",
      0x39 => "9",
      0x3a => ":",
      0x3b => ";",
      0x3c => "<",
      0x3d => "=",
      0x3e => ">",
      0x3f => "?",
      0x40 => "@",
      0x41 => "A",
      0x42 => "B",
      0x43 => "C",
      0x44 => "D",
      0x45 => "E",
      0x46 => "F",
      0x47 => "G",
      0x48 => "H",
      0x49 => "I",
      0x4a => "J",
      0x4b => "K",
      0x4c => "L",
      0x4d => "M",
      0x4e => "N",
      0x4f => "O",
      0x50 => "P",
      0x51 => "Q",
      0x52 => "R",
      0x53 => "S",
      0x54 => "T",
      0x55 => "U",
      0x56 => "V",
      0x57 => "W",
      0x58 => "X",
      0x59 => "Y",
      0x5a => "Z",
      0x5b => "[",
      0x5c => "\\",
      0x5d => "]",
      0x5e => "^",
      0x5f => "_",
      0x60 => "`",
      0x61 => "a",
      0x62 => "b",
      0x63 => "c",
      0x64 => "d",
      0x65 => "e",
      0x66 => "f",
      0x67 => "g",
      0x68 => "h",
      0x69 => "i",
      0x6a => "j",
      0x6b => "k",
      0x6c => "l",
      0x6d => "m",
      0x6e => "n",
      0x6f => "o",
      0x70 => "p",
      0x71 => "q",
      0x72 => "r",
      0x73 => "s",
      0x74 => "t",
      0x75 => "u",
      0x76 => "v",
      0x77 => "w",
      0x78 => "x",
      0x79 => "y",
      0x7a => "z",
      0x7b => "{",
      0x7c => "|",
      0x7d => "}",
      0x7e => "~"
    }

    # Printable characters including escape characters.
    #
    # @since 1.0.0
    ESCAPE_CHARS = {
      0x00 => "\\0",
      0x07 => "\\a",
      0x08 => "\\b",
      0x09 => "\\t",
      0x0a => "\\n",
      0x0b => "\\v",
      0x0c => "\\f",
      0x0d => "\\r"
    }

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

    # Mapping of values to their character strings.
    #
    # @return [Proc]
    #
    # @since 1.0.0
    attr_reader :printable

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
    def initialize(type: :byte, columns: nil, base: nil)
      @type = TYPES.fetch(type) do
                raise(ArgumentError,"unsupported type: #{type.inspect}")
              end

      @reader = Reader.new(@type)

      @columns = columns || (DEFAULT_COLUMNS / @type.size)

      case @type
      when Type::Float
        @base = base || 10

        case @base
        when 16
          @max_digits = 20 # ("%a" % Float::MAX).length
          @format     = "% #{@max_digits}a"
        when 10
          @max_digits = case @type.size
                        when 4 then 13
                        when 8 then 23
                        end

          @format = "% #{@max_digits}g"
        else
          raise(ArgumentError,"float units can only be printed in base 10")
        end
      else
        @base = base || 16

        case @base
        when 16
          @max_digits = case @type.size
                        when 1 then 2  # 0xff.to_s(16).length
                        when 2 then 4  # 0xffff.to_s(16).length
                        when 4 then 8  # 0xffffffff.to_s(16).length
                        when 8 then 16 # 0xffffffffffffffff.to_s(16).length
                        end

          @format = if @type.signed? then "% .#{@max_digits}x"
                    else                  "%.#{@max_digits}x"
                    end
        when 10
          @max_digits = case @type.size
                        when 1 then 3  # 0xff.to_s(10).length
                        when 2 then 5  # 0xffff.to_s(10).length
                        when 4 then 10 # 0xffffffff.to_s(10).length
                        when 8 then 20 # 0xffffffffffffffff.to_s(10).length
                        end

          @format = if @type.signed? then "% #{@max_digits}.d"
                    else                  "%#{@max_digits}.d"
                    end
        when 8
          @max_digits = case @type.size
                        when 1 then 3  # 0xff.to_s(7).length
                        when 2 then 6  # 0xffff.to_s(7).length
                        when 4 then 11 # 0xffffffff.to_s(7).length
                        when 8 then 22 # 0xffffffffffffffff.to_s(7).length
                        end

          @format = if @type.signed? then "% .#{@max_digits}o"
                    else                  "%.#{@max_digits}o"
                    end
        when 2
          @max_digits = case @type.size
                        when 1 then 8  # 0xff.to_s(2).length
                        when 2 then 16 # 0xffff.to_s(2).length
                        when 4 then 32 # 0xffffffff.to_s(2).length
                        when 8 then 64 # 0xffffffffffffffff.to_s(2).length
                        end

          @format = if @type.signed? then "% .#{@max_digits}b"
                    else                  "%.#{@max_digits}b"
                    end
        else
          raise(ArgumentError,"unsupported base: #{base.inspect}")
        end
      end

      @numeric = case @type
                 when Type::Char, Type::UChar
                   Hash.new do |hash,key|
                     hash[key] = if (char = PRINTABLE[key])
                                   "  #{char}"
                                 elsif (char = ESCAPE_CHARS[key])
                                   " #{char}"
                                 else
                                   sprintf(@format,key)
                                 end
                   end
                 else
                   if @type.size == 1
                     Hash.new do |hash,key|
                       hash[key] = sprintf(@format,key)
                     end
                   else
                     ->(value) { sprintf(@format,value) }
                   end
                 end

      @printable = case @type
                   when Type::Char, Type::UChar
                     nil # disable the printable characters for chars
                   when Type::UInt8
                     ->(value) { PRINTABLE.fetch(value,UNPRINTABLE) }
                   when Type::UInt
                     ->(value) {
                       PRINTABLE.fetch(value) do
                         # XXX: https://github.com/jruby/jruby/issues/6652
                         char = value.chr(Encoding::UTF_8) rescue nil
                         char || UNPRINTABLE
                       end
                     }
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

      numeric   = Array.new(@columns)
      printable = Array.new(@columns)

      @reader.each(data) do |word|
        numeric[count]   = @numeric[word]
        printable[count] = @printable[word] if @printable

        count += 1

        if count >= @columns
          if @printable
            yield index, numeric, printable
          else
            yield index, numeric
          end

          index += slice_size
          count = 0
        end
      end

      if count > 0
        # yield the remaining data
        if @printable
          yield index, numeric[0,count], printable[0,count]
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

      chars_per_column = if @type.signed? then @max_digits + 1
                         else                  @max_digits
                         end
      numeric_width = ((chars_per_column * @columns) + (@columns - 1))
      index_format = "%.8x"
      spacer = "  "

      if @printable
        format_string = "#{index_format}#{spacer}%-#{numeric_width}s#{spacer}|%s|#{$/}"

        index = each(data) do |index,numeric,printable|
          yield sprintf(format_string,index,numeric.join(' '),printable.join)
        end
      else
        format_string = "#{index_format}#{spacer}%-#{numeric_width}s"

        index = each(data) do |index,numeric,printable|
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
