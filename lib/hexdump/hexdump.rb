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
  # Widths for formatted numbers
  WIDTHS = {
    :hexadecimal => {
      1 => 2,
      2 => 4,
      4 => 8,
      8 => 16
    },

    :decimal => {
      1 => 3,
      2 => 5,
      4 => 10,
      8 => 20
    },

    :octal => {
      1 => 3,
      2 => 6,
      4 => 11,
      8 => 22
    },

    :binary => {
      1 => 8,
      2 => 16,
      4 => 32,
      8 => 64
    }
  }

  # Format Strings for the various bases
  FORMATS = {
    :hexadecimal => proc { |width| "%.#{width}x" },
    :decimal => proc { |width| "%#{width}.d" },
    :octal => proc { |width| "%.#{width}o" },
    :binary => proc { |width| "%.#{width}b" }
  }

  #
  # Iterates over every word within the data.
  #
  # @param [#each_byte] data
  #   The data containing bytes.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Integer] :word_size (1)
  #   The number of bytes within each word.
  #
  # @option options [:little, :bit] :endian (:little)
  #   The endianness of each word.
  #
  # @yield [word]
  #   The given block will be passed each word within the data.
  #
  # @yieldparam [Integer]
  #   An unpacked word from the data.
  #
  # @return [Enumerator]
  #   If no block is given, an Enumerator will be returned.
  #
  # @raise [ArgumentError]
  #   The given data does not define the `#each_byte` method.
  #
  # @since 0.2.0
  #
  def Hexdump.each_word(data,options={},&block)
    return enum_for(:each_word,data,options) unless block

    unless data.respond_to?(:each_byte)
      raise(ArgumentError,"the data to hexdump must define #each_byte")
    end

    word_size = options.fetch(:word_size,1)
    endian = options.fetch(:endian,:little)

    if word_size > 1
      word = 0
      count = 0

      init_shift = if endian == :big
                     ((word_size - 1) * 8)
                   else
                     0
                   end
      shift = init_shift

      data.each_byte do |b|
        word |= (b << shift)

        if endian == :big
          shift -= 8
        else
          shift += 8
        end

        count += 1

        if count >= word_size
          yield word

          word = 0
          count = 0
          shift = init_shift
        end
      end

      # yield the remaining word
      yield word if count > 0
    else
      data.each_byte(&block)
    end
  end

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
  #   The given data does not define the `#each_byte` method, or
  #   the `:output` value does not support the `#<<` method.
  #
  def Hexdump.dump(data,options={})
    output = options.fetch(:output,STDOUT)

    unless output.respond_to?(:<<)
      raise(ArgumentError,":output must support the #<< method")
    end

    base = case options[:base]
           when :hexadecimal, :hex, 16
             :hexadecimal
           when :decimal, :dec, 10
             :decimal
           when :octal, :oct, 8
             :octal
           when :binary, :bin, 2
             :binary
           else
             :hexadecimal
           end

    word_size = options.fetch(:word_size,1)
    width = (options.fetch(:width,16) / word_size)
    ascii = options.fetch(:ascii,false)

    format_width = WIDTHS[base][word_size]
    format = FORMATS[base][format_width]

    format_word = if ascii 
                    lambda { |word|
                      if (word >= 0x20 && word <= 0x7e)
                        word.chr
                      else
                        (format % word)
                      end
                    }
                  else
                    lambda { |word| (format % word) }
                  end

    print_word = if word_size == 1
                   lambda { |word|
                     if (word >= 0x20 && word <= 0x7e)
                       word.chr
                     else
                       '.'
                     end
                   }
                 elsif RUBY_VERSION > '1.9.'
                   lambda { |word| word.chr(Encoding::UTF_8) }
                 else
                   lambda { |word| '.' }
                 end

    bytes_segment_width = ((width * format_width) + (width - 1))
    line_format = "%.8x  %-#{bytes_segment_width}s  |%s|\n"
    index = 0

    each_word(data,options).each_slice(width) do |words|
      bytes_segment = words.map(&format_word)
      print_segment = words.map(&print_word)

      if block_given?
        yield(index,bytes_segment,print_segment)
      else
        output << sprintf(
          line_format,
          index,
          bytes_segment.join(' '),
          print_segment.join
        )
      end

      index += (width * word_size)
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
