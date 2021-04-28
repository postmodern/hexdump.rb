require 'spec_helper'
require 'hexdump'

describe Hexdump do
  describe ".dump" do
    let(:bytes) { [0x41, 0x42, 0x43, 0x44, 0x45] }
    let(:chars) { bytes.map(&:chr) }
    let(:data)  { chars.join }
    let(:hex_chars) { ['41', '42', '43', '44', '45'] }

    it "should hexdump the given data" do
      yielded_indices = []
      yielded_numeric = []
      yielded_printable = []

      subject.dump(data) do |index,numeric,printable|
        yielded_indices << index
        yielded_numeric += numeric
        yielded_printable += printable
      end

      expect(yielded_indices).to eq([0x00000000])
      expect(yielded_numeric).to be == hex_chars
      expect(yielded_printable).to be == chars
    end
  end
end
