require 'spec_helper'
require 'hexdump/core_ext'

describe "Hexdump core_ext" do
  it "should include Hexdump::Mixin into String" do
    expect(String).to include(Hexdump::Mixin)
  end

  it "should include Hexdump::Mixin into StringIO" do
    expect(StringIO).to include(Hexdump::Mixin)
  end

  it "should include Hexdump::Mixin into IO" do
    expect(IO).to include(Hexdump::Mixin)
  end

  it "should define File.hexdump" do
    expect(File).to respond_to(:hexdump)
  end

  it "should include Hexdump::ModuleMethods into ::Kernel" do
    expect(self.class).to include(Hexdump::ModuleMethods)
  end
end
