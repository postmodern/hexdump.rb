require 'hexdump/format_string'

module Hexdump
  module Numeric
    module Base
      #
      # @api private
      #
      # @since 1.0.0
      #
      class Decimal < FormatString

        INT_SIZE_TO_WIDTH = {
          1 => 3,  # 0xff.to_s(10).length
          2 => 5,  # 0xffff.to_s(10).length
          4 => 10, # 0xffffffff.to_s(10).length
          8 => 20  # 0xffffffffffffffff.to_s(10).length
        }

        FLOAT_SIZE_TO_WIDTH = {
          4 => 12,
          8 => 20
        }

        # @return [Integer]
        attr_reader :width

        #
        # Initializes the decimal format.
        #
        # @param [Type:Int, Type::UInt, Type::Float] type
        #
        def initialize(type)
          widths = case type
                   when Type::Float then FLOAT_SIZE_TO_WIDTH
                   else                  INT_SIZE_TO_WIDTH
                   end

          @width = widths.fetch(type.size) do
                     raise(NotImplementedError,"type #{type} with unsupported size #{type.size}")
                   end

          case type
          when Type::Float
            super("% #{@width}e"); @width += 1
          else
            if type.signed?
              super("% #{@width}.d"); @width += 1
            else
              super("%#{@width}.d")
            end
          end
        end

      end
    end
  end
end
