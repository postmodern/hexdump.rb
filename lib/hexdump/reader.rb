# frozen_string_literal: true

require 'hexdump/type'

module Hexdump
  #
  # @api private
  #
  # @since 1.0.0
  #
  class Reader

    # The type to decode the data as.
    #
    # @return [Type]
    attr_reader :type

    # Controls whether to offset N number of bytes before starting to read data.
    #
    # @return [Integer, nil]
    attr_reader :offset

    # Controls control many bytes to read.
    #
    # @return [Integer, nil]
    attr_reader :length

    #
    # Initializes the reader.
    #
    # @param [Type] type
    #   The type to decode the data as.
    #
    # @param [Integer, nil] offset
    #   Controls whether to offset N number of bytes before starting to read
    #   data.
    #
    # @param [Integer, nil] length
    #   Controls control many bytes to read.
    #
    # @param [Boolean] zero_pad
    #   Controls whether the remaining data will be padded with zeros.
    #
    def initialize(type, offset: nil, length: nil, zero_pad: false)
      @type     = type
      @offset   = offset
      @length   = length
      @zero_pad = zero_pad
    end

    def zero_pad?
      @zero_pad
    end

    #
    # Reads each byte from the given data.
    #
    # @yield [byte]
    #
    # @yieldparam [Integer] byte
    #
    # @return [Enumerator]
    #
    # @raise [ArgumentError]
    #
    def each_byte(data)
      return enum_for(__method__,data) unless block_given?

      unless data.respond_to?(:each_byte)
        raise(ArgumentError,"the given data must respond to #each_byte")
      end

      count = 0

      data.each_byte do |b|
        count += 1

        # offset the first @offset number of bytes
        if @offset.nil? || count > @offset
          yield b
        end

        # stop reading after @length number of bytes
        break if @length && count >= @length
      end
    end

    #
    # Reads each string of the same number of bytes as the {#type}'s
    # {Type#size size}.
    #
    # @param [#each_byte] data
    #
    # @yield [slice]
    #
    # @yieldparam [String] slice
    #
    # @raise [ArgumentError]
    #
    def each_slice(data)
      return enum_for(__method__,data) unless block_given?

      unless data.respond_to?(:each_byte)
        raise(ArgumentError,"the given data must respond to #each_byte")
      end

      count = 0

      if @type.size == 1
        each_byte(data) do |b|
          yield b.chr
        end
      else
        buffer = String.new("\0" * @type.size, capacity: @type.size,
                                               encoding: Encoding::BINARY)
        index  = 0

        each_byte(data) do |b|
          buffer[index] = b.chr(Encoding::BINARY)
          index += 1

          if index >= @type.size
            yield buffer.dup
            index = 0
          end
        end

        if index > 0
          if @zero_pad
            # zero pad the rest of the buffer
            (index..(@type.size - 1)).each do |i|
              buffer[i] = "\0"
            end

            yield buffer
          else
            # yield the reamining partial buffer
            yield buffer[0,index]
          end
        end
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, uint]
    #
    # @yieldparam [String] raw
    #
    # @yieldparam [Integer, nil] uint
    #
    # @return [Enumerator]
    #
    # @raise [ArgumentError]
    #
    def each_uint(data,&block)
      return enum_for(__method__,data) unless block_given?

      unless data.respond_to?(:each_byte)
        raise(ArgumentError,"the given data must respond to #each_byte")
      end

      if @type.size == 1
        each_byte(data) do |b|
          yield b.chr, b
        end
      else
        pack_format = case @type.size
                      when 1
                        'c'
                      when 2
                        case @type.endian
                        when :little then 'S<'
                        when :big    then 'S>'
                        else
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                        end
                      when 4
                        case @type.endian
                        when :little then 'L<'
                        when :big    then 'L>'
                        else
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                        end
                      when 8
                        case @type.endian
                        when :little then 'Q<'
                        when :big    then 'Q>'
                        else
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                        end
                      else
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.inspect}")
                      end

        each_slice(data) do |slice|
          yield slice, slice.unpack1(pack_format)
        end
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, int]
    #
    # @yieldparam [String] raw
    #
    # @yieldparam [Integer, nil] int
    #
    # @return [Enumerator]
    #
    def each_int(data)
      return enum_for(__method__,data) unless block_given?

      pack_format = case @type.size
                    when 1
                      'c'
                    when 2
                      case @type.endian
                      when :little then 's<'
                      when :big    then 's>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                      end
                    when 4
                      case @type.endian
                      when :little then 'l<'
                      when :big    then 'l>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                      end
                    when 8
                      case @type.endian
                      when :little then 'q<'
                      when :big    then 'q>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                      end
                    else
                      raise(TypeError,"unsupported type size #{@type.size} for #{@type.inspect}")
                    end

      each_slice(data) do |slice|
        yield slice, slice.unpack1(pack_format)
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, float]
    #
    # @yieldparam [String] raw
    #
    # @yieldparam [Float, nil] float
    #
    # @return [Enumerator]
    #
    def each_float(data)
      return enum_for(__method__,data) unless block_given?

      pack_format = case @type.endian
                    when :little
                      case @type.size
                      when 4 then 'e'
                      when 8 then 'E'
                      else
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.inspect}")
                      end
                    when :big
                      case @type.size
                      when 4 then 'g'
                      when 8 then 'G'
                      else
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.inspect}")
                      end
                    else
                      raise(TypeError,"unsupported endian #{@type.endian} for #{@type.inspect}")
                    end

      each_slice(data) do |slice|
        yield slice, slice.unpack1(pack_format)
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, value]
    #
    # @yieldparam [String] raw
    #
    # @yieldparam [Integer, Float, nil] value
    #
    # @return [Enumerator]
    #
    def each(data,&block)
      return enum_for(__method__,data) unless block

      case @type
      when Type::UInt
        each_uint(data,&block)
      when Type::Float
        each_float(data,&block)
      when Type::Int
        each_int(data,&block)
      else
        raise(TypeError,"unsupported type: #{@type.inspect}")
      end
    end

  end
end
