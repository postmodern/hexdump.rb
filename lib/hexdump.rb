require 'hexdump/module_methods'
require 'hexdump/core_ext'
require 'hexdump/version'

module Hexdump
  extend ModuleMethods

  #
  # @see hexdump
  #
  def self.dump(data,**kwargs)
    hexdump(data,**kwargs)
  end
end
