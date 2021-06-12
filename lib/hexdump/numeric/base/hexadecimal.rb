require 'hexdump/numeric/format_string'

module Hexdump
  module Numeric
    module Base
      class Hexadecimal < FormatString

        INT_SIZE_TO_WIDTH = {
          1 => 2, # 0xff.to_s(16).length
          2 => 4, # 0xffff.to_s(16).length
          4 => 8, # 0xffffffff.to_s(16).length
          8 => 16 # 0xffffffffffffffff.to_s(16).length
        }

        FLOAT_WIDTH = 20

        # @return [Integer]
        attr_reader :width

        #
        # Initializes the hexadecimal format.
        #
        # @param [Type::Int, Type::UInt, Type::Float] type
        #
        def initialize(type)
          case type
          when Type::Float
            if RUBY_ENGINE == 'jruby'
              begin
                "%a" % 1.0
              rescue ArgumentError
                raise(NotImplementedError,"jruby #{RUBY_ENGINE_VERSION} does not support the \"%a\" format string")
              end
            end

            # NOTE: jruby does not currently support the %a format string
            @width = FLOAT_WIDTH
            super("% #{@width}a"); @width += 1
          else
            @width = INT_SIZE_TO_WIDTH.fetch(type.size) do
                       raise(NotImplementedError,"type #{type} with unsupported size #{type.size}")
                     end

            if type.signed?
              super("% .#{@width}x"); @width += 1
            else
              super("%.#{@width}x")
            end
          end
        end

      end
    end
  end
end
