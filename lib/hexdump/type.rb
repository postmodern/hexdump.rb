module Hexdump
  #
  # @api private
  #
  # @since 1.0.0
  #
  class Type

    # The endian-ness of the type.
    #
    # @return [:little, :big, nil]
    attr_reader :endian

    # The size in bytes of the type.
    #
    # @return [1, 2, 4, 8]
    attr_reader :size

    #
    # Initializes the type.
    #
    # @param [Symbol] name
    #   The type's name.
    #
    # @param [:little, :big, nil] endian
    #   The endianness of the type. `nil` indicates the type has no endianness.
    #
    # @param [1, 2, 4, 8] size
    #   The type's size in bytes.
    #
    # @param [Boolean] signed
    #   Indicates whether the type is signed or unsigned.
    #
    # @raise [ArgumentError]
    #   Invalid `endian:` or `size:` values.
    #
    def initialize(size: , endian: nil, signed: )
      @endian = endian
      @size   = size
      @signed = signed
    end

    # 
    # Whether the type is signed.
    #
    # @return [Boolean]
    #
    def signed?
      @signed
    end

    # 
    # Whether the type is unsigned.
    #
    # @return [Boolean]
    #
    def unsigned?
      !@signed
    end

    # The native endian-ness.
    NATIVE_ENDIAN = if [0x1].pack('I') == [0x1].pack('N')
                      :big
                    else
                      :little
                    end

    #
    # Represents a signed integer type.
    #
    class Int < self

      #
      # Initializes the int type.
      #
      # @param [:little, :big] endian (NATIVE_ENDIAN)
      #   The endian-ness of the int type.
      #
      def initialize(endian: NATIVE_ENDIAN, **kwargs)
        super(signed: true, endian: endian, **kwargs)
      end

    end

    class Int8 < Int

      #
      # @see Int#initialize
      #
      def initialize(**kwargs)
        super(size: 1, endian: nil, **kwargs)
      end

    end

    class Int16 < Int

      #
      # @see Int#initialize
      #
      def initialize(**kwargs)
        super(size: 2, **kwargs)
      end

    end

    class Int32 < Int

      #
      # @see Int#initialize
      #
      def initialize(**kwargs)
        super(size: 4, **kwargs)
      end

    end

    class Int64 < Int

      #
      # @see Int#initialize
      #
      def initialize(**kwargs)
        super(size: 8, **kwargs)
      end

    end

    #
    # Represents a unsigned integer type.
    #
    class UInt < self

      #
      # Initializes the uint type.
      #
      # @param [:little, :big] endian (NATIVE_ENDIAN)
      #   The endian-ness of the uint type.
      #
      def initialize(endian: NATIVE_ENDIAN, **kwargs)
        super(signed: false, endian: endian, **kwargs)
      end

    end

    class UInt8 < UInt

      #
      # @see UInt#initialize
      #
      def initialize(**kwargs)
        super(size: 1, endian: nil, **kwargs)
      end

    end

    class UInt16 < UInt

      #
      # @see UInt#initialize
      #
      def initialize(**kwargs)
        super(size: 2, **kwargs)
      end

    end

    class UInt32 < UInt

      #
      # @see UInt#initialize
      #
      def initialize(**kwargs)
        super(size: 4, **kwargs)
      end

    end

    class UInt64 < UInt

      #
      # @see UInt#initialize
      #
      def initialize(**kwargs)
        super(size: 8, **kwargs)
      end

    end

    #
    # Represents a single-byte character.
    #
    class Char < Int8
    end

    #
    # Represents a single-byte unsigned character.
    #
    class UChar < UInt8
    end

    #
    # Represents a floating point type.
    #
    class Float < self

      #
      # Initializes the float type.
      #
      # @param [:little, :big] endian (NATIVE_ENDIAN)
      #   The endian-ness of the float type.
      #
      def initialize(endian: NATIVE_ENDIAN, **kwargs)
        super(signed: true, endian: endian, **kwargs)
      end

    end

    class Float32 < Float

      def initialize(**kwargs)
        super(size: 4, **kwargs)
      end

    end

    class Float64 < Float

      def initialize(**kwargs)
        super(size: 8, **kwargs)
      end

    end

  end
end
