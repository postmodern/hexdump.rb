require 'spec_helper'
require 'hexdump'

describe Hexdump do
  let(:data)    { ("A" * 32) + ("B" * 32) + ("C" * 32) }
  let(:hexdump) { Hexdump::Hexdump.new.dump(data) }

  describe ".hexdump" do
    it "must write the hexdump lines of the given data to the output" do
      expect {
        subject.hexdump(data)
      }.to output(hexdump).to_stdout
    end
  end

  describe ".dump" do
    it "must write the hexdump lines of the given data to the output" do
      expect {
        subject.dump(data)
      }.to output(hexdump).to_stdout
    end
  end
end
