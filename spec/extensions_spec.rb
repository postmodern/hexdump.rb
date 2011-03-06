require 'spec_helper'
require 'hexdump/extensions'

describe "Hexdump extensions" do
  it "should include Hexdump into String" do
    String.should include(Hexdump)
  end

  it "should include Hexdump into IO" do
    IO.should include(Hexdump)
  end

  it "should define File.hexdump" do
    File.should respond_to(:hexdump)
  end
end
