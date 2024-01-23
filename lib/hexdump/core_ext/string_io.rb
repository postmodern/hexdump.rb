require_relative '../mixin'

require 'stringio'

class StringIO

  include Hexdump::Mixin

end
