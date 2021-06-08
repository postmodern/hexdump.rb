require 'spec_helper'
require 'hexdump/char_map/ascii'

describe Hexdump::CharMap::ASCII do
  describe ".[]" do
    context "when given a byte that maps to a printable character" do
      it "must return the printable character" do
        expect(subject[0x41]).to eq('A')
      end
    end

    context "when given a byte that does not map to a printable character" do
      it "must return '.'" do
        expect(subject[0x00]).to eq('.')
      end
    end
  end
end
