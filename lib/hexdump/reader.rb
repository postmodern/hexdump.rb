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

    #
    # Initializes the reader.
    #
    # @param [Type] type
    #   Thetype to decode the data as.
    #
    def initialize(type)
      @type = type
    end

    #
    # Reads each byte from the data.
    #
    # @param [#each_byte] data
    #
    # @yield [byte]
    #
    # @yieldparam [Integer] byte
    #
    # @return [Enumerator]
    #
    # @raise [ArgumentError]
    #
    def each_byte(data,&block)
      unless data.respond_to?(:each_byte)
        raise(ArgumentError,"the given data must respond to #each_byte")
      end

      data.each_byte(&block)
    end

    #
    # @param [#each_byte] data
    #
    # @yield [uint]
    #
    # @yieldparam [Integer] uint
    #
    # @return [Enumerator]
    #
    # @raise [ArgumentError]
    #
    def each_uint(data)
      return enum_for(__method__,data) unless block_given?

      unless data.respond_to?(:each_byte)
        raise(ArgumentError,"the given data must respond to #each_byte")
      end

      uint  = 0
      count = 0

      init_shift = if @type.endian == :big then ((@type.size - 1) * 8)
                   else                         0
                   end
      shift = init_shift

      data.each_byte do |b|
        uint |= (b << shift)

        if @type.endian == :big then shift -= 8
        else                         shift += 8
        end

        count += 1

        if count >= @type.size
          yield uint

          uint  = 0
          count = 0
          shift = init_shift
        end
      end

      # yield the remaining uint
      yield uint if count > 0
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

      buffer = String.new("\0" * @type.size, encoding: Encoding::BINARY)
      index  = 0

      data.each_byte do |b|
        buffer[index] = b.chr(Encoding::BINARY)
        index += 1

        if index >= @type.size
          yield buffer
          index = 0
        end
      end

      if index > 0
        # zero pad the partially filled buffer
        until index >= @type.size
          buffer[index] = "\0"
          index += 1
        end

        yield buffer
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [int]
    #
    # @yieldparam [Integer] int
    #
    # @return [Enumerator]
    #
    def each_int(data)
      return enum_for(__method__,data) unless block_given?

      pack_format = case @type.size
                    when 2
                      case @type.endian
                      when :little then 's<'
                      when :big    then 's>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                      end
                    when 4
                      case @type.endian
                      when :little then 'l<'
                      when :big    then 'l>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                      end
                    when 8
                      case @type.endian
                      when :little then 'q<'
                      when :big    then 'q>'
                      else
                        raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                      end
                    else
                      raise(TypeError,"unsupported type size #{@type.size} for #{@type.name}")
                    end

      each_slice(data) do |slice|
        yield slice.unpack(pack_format).first
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [float]
    #
    # @yieldparam [Float] float
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
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.name}")
                      end
                    when :big
                      case @type.size
                      when 4 then 'g'
                      when 8 then 'G'
                      else
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.name}")
                      end
                    else
                      raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                    end

      each_slice(data) do |slice|
        yield slice.unpack(pack_format).first
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [value]
    #
    # @yieldparam [Integer, Float] value
    #
    # @return [Enumerator]
    #
    def each(data,&block)
      return enum_for(__method__,data) unless block

      if @type.size == 1
        each_byte(data,&block)
      elsif @type.kind_of?(Type::Float)
        each_float(data,&block)
      elsif @type.signed?
        each_int(data,&block)
      else
        each_uint(data,&block)
      end
    end

  end
end
