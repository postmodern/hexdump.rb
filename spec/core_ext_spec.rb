require 'spec_helper'
require 'hexdump/core_ext'

describe "Hexdump core_ext" do
  it "should include Hexdump into String" do
    expect(String).to include(Hexdump::Mixin)
  end

  it "should include Hexdump into StringIO" do
    expect(StringIO).to include(Hexdump::Mixin)
  end

  it "should include Hexdump into IO" do
    expect(IO).to include(Hexdump::Mixin)
  end

  it "should define File.hexdump" do
    expect(File).to respond_to(:hexdump)
  end

  it "should define Kernel.hexdump" do
    expect(Kernel).to be_kind_of(Hexdump::ModuleMethods)
    expect(Kernel).to respond_to(:hexdump)
  end
end
