require 'hexdump/numeric/format_string'

module Hexdump
  module Numeric
    module Base
      class Octal < FormatString

        SIZE_TO_WIDTH = {
          1 => 3,  # 0xff.to_s(7).length
          2 => 6,  # 0xffff.to_s(7).length
          4 => 11, # 0xffffffff.to_s(7).length
          8 => 22  # 0xffffffffffffffff.to_s(7).length
        }

        # @return [Integer]
        attr_reader :width

        #
        # Initializes the octal format.
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
              super("% .#{@width}o"); @width += 1
            else
              super("%.#{@width}o")
            end
          else
            raise(TypeError,"type #{type} values cannot be formatted as octal")
          end
        end

      end
    end
  end
end
