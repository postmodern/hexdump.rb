require 'spec_helper'
require 'hexdump/char_map/utf8'

describe Hexdump::CharMap::UTF8 do
  describe ".[]" do
    context "when given a byte that maps to a printable ASCII character" do
      it "must return the printable character" do
        expect(subject[0x41]).to eq('A')
      end
    end

    context "when given a byte that does not map to a printable character" do
      it "must return '.'" do
        expect(subject[0x00]).to eq('.')
      end
   end

    context "when given a multi-byte value that maps to a UTF8 character" do
      it "must return the UTF8 character" do
        expect(subject[0x4241]).to eq("䉁")
      end
    end

    context "when given a multi-byte value that does not map to UTF8" do
      it "must reutrn '.'" do
        expect(subject[0xd800]).to eq('.')
      end
    end
  end
end
