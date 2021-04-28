module Hexdump
  #
  # @api private
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
    #
    # @param [:little, :big, nil] endian
    #
    # @param [1, 2, 4, 8] size
    #
    # @param [Boolean] signed
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
    # Whether the type is signed or unsigned.
    #
    # @return [Boolean]
    #
    def signed?
      @signed
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

  end
end
