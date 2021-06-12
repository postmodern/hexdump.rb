require 'hexdump/core_ext/io'

class File

  #
  # Hexdumps the contents of a file.
  #
  # @param [String] path
  #   The path of the file.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @see Hexdump.dump
  #
  def self.hexdump(path,**kwargs,&block)
    self.open(path,'rb') do |file|
      file.hexdump(**kwargs,&block)
    end
  end

end
