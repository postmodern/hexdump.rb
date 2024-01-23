require_relative 'hexdump/module_methods'
require_relative 'hexdump/core_ext'
require_relative 'hexdump/version'

module Hexdump
  extend ModuleMethods

  #
  # @see hexdump
  #
  def self.dump(data,**kwargs)
    hexdump(data,**kwargs)
  end
end
