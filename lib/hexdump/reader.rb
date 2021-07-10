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

      if @type.size == 1
        data.each_byte do |b|
          yield b.chr
        end
      else
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
          # yield the reamining partial buffer
          yield buffer[0,index]
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
    # @yieldparam [Integer] uint
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
        data.each_byte do |b|
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
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                        end
                      when 4
                        case @type.endian
                        when :little then 'L<'
                        when :big    then 'L>'
                        else
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                        end
                      when 8
                        case @type.endian
                        when :little then 'Q<'
                        when :big    then 'Q>'
                        else
                          raise(TypeError,"unsupported endian #{@type.endian} for #{@type.name}")
                        end
                      else
                        raise(TypeError,"unsupported type size #{@type.size} for #{@type.name}")
                      end

        each_slice(data) do |slice|
          yield slice, slice.unpack(pack_format).first
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
    # @yieldparam [Integer] int
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
        yield slice, slice.unpack(pack_format).first
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, float]
    #
    # @yieldparam [String] raw
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
        yield slice, slice.unpack(pack_format).first
      end
    end

    #
    # @param [#each_byte] data
    #
    # @yield [raw, value]
    #
    # @yieldparam [String] raw
    #
    # @yieldparam [Integer, Float] value
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
