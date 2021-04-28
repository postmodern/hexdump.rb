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
    # @see Hexdump.dump
    #
    def hexdump(**kwargs,&block)
      Hexdump.dump(self,**kwargs,&block)
    end
  end
end
