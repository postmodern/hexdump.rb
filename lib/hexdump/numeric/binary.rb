require 'hexdump/numeric/exceptions'
require 'hexdump/format_string'

module Hexdump
  module Numeric
    #
    # @api private
    #
    # @since 1.0.0
    #
    class Binary < FormatString

      SIZE_TO_WIDTH = {
        1 => 8,  # 0xff.to_s(2).length
        2 => 16, # 0xffff.to_s(2).length
        4 => 32, # 0xffffffff.to_s(2).length
        8 => 64  # 0xffffffffffffffff.to_s(2).length
      }

      # @return [Integer]
      attr_reader :width

      #
      # Initializes the binary format.
      #
      # @param [Type::Int, Type::UInt] type
      #
      # @raise [NotImplementedError]
      #
      # @raise [IncompatibleTypeError]
      #
      # @raise [TypeError]
      #
      def initialize(type)
        case type
        when Type::Int, Type::UInt
          @width = SIZE_TO_WIDTH.fetch(type.size) do
            raise(NotImplementedError,"type #{type} with unsupported size #{type.size}")
          end

          if type.signed?
            super("% .#{@width}b"); @width += 1
          else
            super("%.#{@width}b")
          end
        when Type::Float
          raise(IncompatibleTypeError,"cannot format floating-point numbers in binary")
        else
          raise(TypeError,"unsupported type: #{type.inspect}")
        end
      end

    end
  end
end
