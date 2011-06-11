require 'spec_helper'

require 'hexdump'

describe Hexdump do
  describe "#hexdump" do
    let(:bytes) { [104, 101, 108, 108, 111] }
    let(:hex_chars) { ['68', '65', '6c', '6c', '6f'] }

    subject do
      obj = Object.new.extend(Hexdump)

      stub = obj.stub!(:each_byte)
      bytes.each { |b| stub = stub.and_yield(b) }

      obj
    end

    it "should hexdump the object" do
      chars = []

      subject.hexdump do |index,hex,print|
        chars += hex
      end

      chars.should == hex_chars
    end
  end
end
