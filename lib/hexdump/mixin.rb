require 'hexdump/hexdump'

module Hexdump
  #
  # @api public
  #
  # @since 1.0.0
  #
  module Mixin
    #
    # Hexdumps the object.
    #
    # @see Hexdump.print
    #
    def hexdump(**kwargs,&block)
      Hexdump.print(self,**kwargs,&block)
    end
  end
end
