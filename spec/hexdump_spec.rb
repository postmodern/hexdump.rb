require 'spec_helper'
require 'hexdump'

describe Hexdump do
  let(:bytes) { [104, 101, 108, 108, 111] }
  let(:hex_chars) { ['68', '65', '6c', '6c', '6f'] }
  let(:decimal_chars) { ['104', '101', '108', '108', '111'] }
  let(:octal_chars) { ['0150', '0145', '0154', '0154', '0157'] }
  let(:binary_chars) { ['01101000', '01100101', '01101100', '01101100', '01101111'] }
  let(:print_chars) { ['h', 'e', 'l', 'l', 'o'] }
  let(:data) { print_chars.join }

  describe "dump" do
    it "should append each line of the hexdump to the output" do
      lines = []
      subject.dump(data, :output => lines)

      lines.length.should == 1
      lines[0].should include(hex_chars.join(' '))
      lines[0].should include(print_chars.join)
    end

    it "should yield the parts of each hexdump line to the given block" do
      lines = []

      subject.dump(data) do |index,hex,print|
        lines << [index, hex, print]
      end

      lines.length.should == 1
      lines[0][0].should == 0
      lines[0][1].should == hex_chars
      lines[0][2].should == print_chars
    end

    it "should provide the index within the data for each line" do
      indices = []

      subject.dump('A' * 100, :width => 10) do |index,hex,print|
        indices << index
      end

      indices.should == [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
    end

    it "should allow configuring the width, in bytes, of each line" do
      widths = []

      subject.dump('A' * 100, :width => 10) do |index,hex,print|
        widths << hex.length
      end

      widths.should == ([10] * 10)
    end

    it "should hexdump the remaining bytes" do
      chars = (['B'] * 4)
      string = chars.join
      leading = ('A' * 100)
      remainder = nil

      subject.dump(leading + string, :width => 10) do |index,hex,print|
        remainder = print
      end

      remainder.should == chars
    end

    it "should provide the hexadecimal characters for each line" do
      chars = []

      subject.dump(data * 100, :width => 10) do |index,hex,print|
        chars += hex
      end

      chars.should == (hex_chars * 100)
    end

    it "should allow printing ASCII characters in place of hex characters" do
      chars = []

      subject.dump(data, :ascii => true) do |index,hex,print|
        chars += hex
      end

      chars.should == print_chars
    end

    it "should provide the print characters for each line" do
      chars = []

      subject.dump(data * 100, :width => 10) do |index,hex,print|
        chars += print
      end

      chars.should == (print_chars * 100)
    end

    it "should map unprintable characters to '.'" do
      unprintable = ((0x00..0x1f).map(&:chr) + (0x7f..0xff).map(&:chr)).join
      chars = []

      subject.dump(unprintable) do |index,hex,print|
        chars += print
      end

      chars.should == (['.'] * unprintable.length)
    end

    it "should support dumping bytes in decimal format" do
      chars = []

      subject.dump(data, :base => :decimal) do |index,hex,print|
        chars += hex
      end

      chars.should == decimal_chars
    end

    it "should support dumping bytes in octal format" do
      chars = []

      subject.dump(data, :base => :octal) do |index,hex,print|
        chars += hex
      end

      chars.should == octal_chars
    end

    it "should support dumping bytes in binary format" do
      chars = []

      subject.dump(data, :base => :binary) do |index,hex,print|
        chars += hex
      end

      chars.should == binary_chars
    end
  end

  describe "#hexdump" do
    subject do
      obj = Object.new.extend(Hexdump)
      obj.stub!(:each_byte).and_return(bytes.enum_for(:each))

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
