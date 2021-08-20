require 'spec_helper'
require 'hexdump/mixin'

describe Hexdump::Mixin do
  class TestMixin

    include Hexdump::Mixin

    def initialize(data)
      @data = data
    end

    def each_byte(&block)
      @data.each_byte(&block)
    end

  end

  let(:data)    { ("A" * 32) + ("B" * 32) + ("C" * 32) }
  let(:hexdump) { Hexdump::Hexdump.new.dump(data) }

  subject { TestMixin.new(data) }

  describe "#hexdump" do
    it "must write the hexdump lines of the object to $stdout" do
      expect {
        subject.hexdump
      }.to output(hexdump).to_stdout
    end
  end
end
