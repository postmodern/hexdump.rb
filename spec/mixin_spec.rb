require 'spec_helper'
require 'hexdump/mixin'

describe Hexdump::Mixin do
  describe "#hexdump" do
    let(:bytes) { [104, 101, 108, 108, 111] }
    let(:hex_chars) { ['68', '65', '6c', '6c', '6f'] }

    subject do
      obj = Object.new.extend(Hexdump::Mixin)

      each_byte = expect(obj).to receive(:each_byte)
      bytes.each do |b|
        each_byte = each_byte.and_yield(b)
      end

      obj
    end

    it "should hexdump the object by calling #each_byte" do
      chars = []

      subject.hexdump do |index,hex,print|
        chars += hex
      end

      expect(chars).to be == hex_chars
    end
  end
end
