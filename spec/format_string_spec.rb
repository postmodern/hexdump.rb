require 'spec_helper'
require 'hexdump/format_string'

describe Hexdump::FormatString do
  let(:fmt) { "%x" }

  subject { described_class.new(fmt) }

  describe "#%" do
    let(:value) { 255 }

    it "must format the given value" do
      expect(subject % value).to eq(fmt % value)
    end
  end

  describe "#to_s" do
    it "must return the format string" do
      expect(subject.to_s).to eq(fmt)
    end
  end
end
