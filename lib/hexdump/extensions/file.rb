require 'hexdump/extensions/io'

class File

  def self.hexdump(path,output=STDOUT,&block)
    self.open(path,'rb') do |file|
      file.hexdump(output,&block)
    end
  end

end
