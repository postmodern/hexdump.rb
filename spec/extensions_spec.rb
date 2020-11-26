require 'spec_helper'
require 'hexdump/extensions'

describe "Hexdump extensions" do
  it "should include Hexdump into String" do
    expect(String).to include(Hexdump)
  end

  it "should include Hexdump into StringIO" do
    expect(StringIO).to include(Hexdump)
  end

  it "should include Hexdump into IO" do
    expect(IO).to include(Hexdump)
  end

  it "should define File.hexdump" do
    expect(File).to respond_to(:hexdump)
  end
end
