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
  # @see IO#hexdump
  #
  def self.hexdump(path,**kwargs)
    self.open(path,'rb') do |file|
      file.hexdump(**kwargs)
    end
  end

end
