require 'spec_helper'

require 'hexdump/dumper'

describe Hexdump::Dumper do
  let(:bytes) { [104, 101, 108, 108, 111] }
  let(:hex_chars) { ['68', '65', '6c', '6c', '6f'] }
  let(:decimal_chars) { ['104', '101', '108', '108', '111'] }
  let(:octal_chars) { ['150', '145', '154', '154', '157'] }
  let(:binary_chars) { ['01101000', '01100101', '01101100', '01101100', '01101111'] }
  let(:print_chars) { ['h', 'e', 'l', 'l', 'o'] }
  let(:data) { print_chars.join }

  it "should only accept known :base values" do
    lambda {
      described_class.new(data, :base => :foo)
    }.should raise_error(ArgumentError)
  end

  it "should only accept known :endian values" do
    lambda {
      described_class.new(data, :endian => :foo)
    }.should raise_error(ArgumentError)
  end

  describe "each_word" do
    let(:data) { 'ABAB' }
    let(:bytes) { [0x41, 0x42, 0x41, 0x42] }
    let(:shorts_le) { [0x4241, 0x4241] }
    let(:shorts_be) { [0x4142, 0x4142] }
    let(:custom_words) { [0x414241, 0x42] }

    it "should check if the data defines '#each_byte'" do
      lambda {
        subject.each_word(Object.new).to_a
      }.should raise_error(ArgumentError)
    end

    it "should iterate over each byte by default" do
      subject.each_word(data).to_a.should == bytes
    end

    it "should allow iterating over custom word-sizes" do
      dumper = described_class.new(:word_size => 3)

      dumper.each_word(data).to_a.should == custom_words
    end

    it "should iterate over little-endian words by default" do
      dumper = described_class.new(:word_size => 2)

      dumper.each_word(data).to_a.should == shorts_le
    end

    it "should iterate over big-endian words" do
      dumper = described_class.new(:word_size => 2, :endian => :big)

      dumper.each_word(data).to_a.should == shorts_be
    end
  end

  describe "#each" do
    it "should yield the parts of each hexdump line to the given block" do
      lines = []

      subject.each(data) do |index,hex,print|
        lines << [index, hex, print]
      end

      lines.length.should == 1
      lines[0][0].should == 0
      lines[0][1].should == hex_chars
      lines[0][2].should == print_chars
    end

    it "should provide the index within the data for each line" do
      dumper = described_class.new(:width => 10)
      indices = []

      dumper.each('A' * 100) do |index,hex,print|
        indices << index
      end

      indices.should == [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
    end

    it "should allow configuring the width, in bytes, of each line" do
      dumper = described_class.new(:width => 10)
      widths = []

      dumper.each('A' * 100) do |index,hex,print|
        widths << hex.length
      end

      widths.should == ([10] * 10)
    end

    it "should hexdump the remaining bytes" do
      dumper = described_class.new(:width => 10)
      chars = (['B'] * 4)
      string = chars.join
      leading = ('A' * 100)
      remainder = nil

      dumper.each(leading + string) do |index,hex,print|
        remainder = print
      end

      remainder.should == chars
    end

    it "should provide the hexadecimal characters for each line" do
      dumper = described_class.new(:width => 10)
      chars = []

      dumper.each(data * 100) do |index,hex,print|
        chars += hex
      end

      chars.should == (hex_chars * 100)
    end

    it "should allow printing ASCII characters in place of hex characters" do
      dumper = described_class.new(:ascii => true)
      chars = []

      dumper.each(data) do |index,hex,print|
        chars += hex
      end

      chars.should == print_chars
    end

    it "should provide the print characters for each line" do
      dumper = described_class.new(:width => 10)
      chars = []

      dumper.each(data * 100) do |index,hex,print|
        chars += print
      end

      chars.should == (print_chars * 100)
    end

    it "should map unprintable characters to '.'" do
      unprintable = ((0x00..0x1f).map(&:chr) + (0x7f..0xff).map(&:chr)).join
      chars = []

      subject.each(unprintable) do |index,hex,print|
        chars += print
      end

      chars.should == (['.'] * unprintable.length)
    end

    it "should support dumping bytes in decimal format" do
      dumper = described_class.new(:base => :decimal)
      chars = []

      dumper.each(data) do |index,hex,print|
        chars += hex
      end

      chars.should == decimal_chars
    end

    it "should support dumping bytes in octal format" do
      dumper = described_class.new(:base => :octal)
      chars = []

      dumper.each(data) do |index,hex,print|
        chars += hex
      end

      chars.should == octal_chars
    end

    it "should support dumping bytes in binary format" do
      dumper = described_class.new(:base => :binary)
      chars = []

      dumper.each(data) do |index,hex,print|
        chars += hex
      end

      chars.should == binary_chars
    end

    context ":word_size" do
      let(:options) { {:word_size => 2, :endian => :little} }

      let(:hex_words) { ['6568', '6c6c', '006f'] }
      let(:decimal_words) { ['25960', '27756', '  111'] }
      let(:octal_words) { ['062550', '066154', '000157'] }
      let(:binary_words) { ['0110010101101000', '0110110001101100', '0000000001101111'] }

      it "should dump words in hexadecimal" do
        dumper = described_class.new(options)
        words = []

        dumper.each(data) do |index,hex,print|
          words += hex
        end

        words.should == hex_words
      end

      it "should dump words in decimal" do
        dumper = described_class.new(options.merge(:base => :decimal))
        words = []

        dumper.each(data) do |index,dec,print|
          words += dec
        end

        words.should == decimal_words
      end

      it "should dump words in octal" do
        dumper = described_class.new(options.merge(:base => :octal))
        words = []

        dumper.each(data) do |index,oct,print|
          words += oct
        end

        words.should == octal_words
      end

      it "should dump words in binary" do
        dumper = described_class.new(options.merge(:base => :binary))
        words = []

        dumper.each(data) do |index,bin,print|
          words += bin
        end

        words.should == binary_words
      end
    end
  end

  describe "#dump" do
    it "should check if the :output supports the '#<<' method" do
      lambda {
        subject.dump(data,Object.new)
      }.should raise_error(ArgumentError)
    end

    it "should append each line of the hexdump to the output" do
      lines = []

      subject.dump(data,lines)

      lines.length.should == 1
      lines[0].should include(hex_chars.join(' '))
      lines[0].should include(print_chars.join)
    end
  end
end
