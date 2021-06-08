require 'hexdump/numeric/format_string'

module Hexdump
  module Numeric
    module Base
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
          else
            raise(TypeError,"#{type} type cannot be formatted as binary")
          end
        end

      end
    end
  end
end
