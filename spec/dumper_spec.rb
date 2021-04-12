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

  describe "#initialize" do
    it "should only accept known base: values" do
      expect {
        described_class.new(base: :foo)
      }.to raise_error(ArgumentError)
    end

    it "should only accept known endian: values" do
      expect {
        described_class.new(endian: :foo)
      }.to raise_error(ArgumentError)
    end
  end

  describe "each_word" do
    let(:data) { 'ABAB' }
    let(:bytes) { [0x41, 0x42, 0x41, 0x42] }

    it "should check if the data defines '#each_byte'" do
      expect {
        subject.each_word(Object.new).to_a
      }.to raise_error(ArgumentError)
    end

    it "should iterate over each byte by default" do
      expect(subject.each_word(data).to_a).to be == bytes
    end

    context "when initialized with a custom word_size:" do
      subject { described_class.new(word_size: 3) }

      let(:custom_words) { [0x414241, 0x42] }

      it "should allow iterating over custom word-sizes" do
        expect(subject.each_word(data).to_a).to be == custom_words
      end
    end

    context "when initialized with default endian:" do
      subject { described_class.new(word_size: 2) }

      let(:shorts_le) { [0x4241, 0x4241] }

      it "should iterate over little-endian words by default" do
        expect(subject.each_word(data).to_a).to be == shorts_le
      end
    end

    context "when initialized with endian: :big" do
      subject { described_class.new(word_size: 2, endian: :big) }

      let(:shorts_be) { [0x4142, 0x4142] }

      it "should iterate over big-endian words" do
        expect(subject.each_word(data).to_a).to be == shorts_be
      end
    end
  end

  describe "#each" do
    it "should yield the parts of each hexdump line to the given block" do
      lines = []

      subject.each(data) do |index,hex,print|
        lines << [index, hex, print]
      end

      expect(lines.length).to be(1)
      expect(lines[0][0]).to be == 0
      expect(lines[0][1]).to be == hex_chars
      expect(lines[0][2]).to be == print_chars
    end

    it "should provide the index within the data for each line" do
      indices = []

      subject.each('A' * (16 * 10)) do |index,hex,print|
        indices << index
      end

      expect(indices).to be == [0, 16, 32, 48, 64, 80, 96, 112, 128, 144]
    end

    context "when initialized with a custom wdith:" do
      let(:width) { 10 }

      subject { described_class.new(width: width) }

      it "should change the width, in bytes, of each line" do
        widths = []
        count  = 10

        subject.each('A' * (width * count)) do |index,hex,print|
          widths << hex.length
        end

        expect(widths).to be == ([width] * count)
      end
    end

    context "when there are leftover bytes" do
      let(:width) { 10 }

      subject { described_class.new(width: width) }

      let(:chars)   { ['B'] * 4 }
      let(:string)  { chars.join }
      let(:leading) { 'A' * 100 }

      it "should hexdump the remaining bytes" do
        remainder = nil

        subject.each(leading + string) do |index,hex,print|
          remainder = print
        end

        expect(remainder).to be == chars
      end
    end

    it "should provide the hexadecimal characters for each line" do
      chars = []
      length = (16 * 10)

      subject.each(data * length) do |index,hex,print|
        chars += hex
      end

      expect(chars).to be == (hex_chars * length)
    end

    context "when initialized with ascii: true" do
      subject { described_class.new(ascii: true) }

      it "should allow printing ASCII characters in place of hex characters" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == print_chars
      end
    end

    it "should provide the print characters for each line" do
      chars = []
      length = (16 * 10)

      subject.each(data * length) do |index,hex,print|
        chars += print
      end

      expect(chars).to be == (print_chars * length)
    end

    it "should map unprintable characters to '.'" do
      unprintable = ((0x00..0x1f).map(&:chr) + (0x7f..0xff).map(&:chr)).join
      chars = []

      subject.each(unprintable) do |index,hex,print|
        chars += print
      end

      expect(chars).to be == (['.'] * unprintable.length)
    end

    context "when initialized with base: :decimal" do
      subject { described_class.new(base: :decimal) }

      it "should support dumping bytes in decimal format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == decimal_chars
      end
    end

    context "when initialized with base: :octal" do
      subject { described_class.new(base: :octal) }

      it "should support dumping bytes in octal format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == octal_chars
      end
    end

    context "when initialized with base: :binary" do
      subject { described_class.new(base: :binary) }

      it "should support dumping bytes in binary format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == binary_chars
      end
    end

    context "when initialized with word_size: and endian:" do
      let(:options) { {:word_size => 2, :endian => :little} }
      let(:hex_words) { ['6568', '6c6c', '006f'] }

      subject { described_class.new(**options) }

      it "should dump words in hexadecimal by default" do
        words = []

        subject.each(data) do |index,hex,print|
          words += hex
        end

        expect(words).to be == hex_words
      end

      context "and base: :decimal" do
        subject { described_class.new(base: :decimal, **options) }

        let(:decimal_words) { ['25960', '27756', '  111'] }

        it "should dump words in decimal" do
          words = []

          subject.each(data) do |index,dec,print|
            words += dec
          end

          expect(words).to be == decimal_words
        end
      end

      context "and base: :octal" do
        subject { described_class.new(base: :octal, **options) }

        let(:octal_words) { ['062550', '066154', '000157'] }

        it "should dump words in octal" do
          words = []

          subject.each(data) do |index,oct,print|
            words += oct
          end

          expect(words).to be == octal_words
        end
      end

      context "and base: :binary" do
        subject { described_class.new(base: :binary, **options) }

        let(:binary_words) { ['0110010101101000', '0110110001101100', '0000000001101111'] }

        it "should dump words in binary" do
          words = []

          subject.each(data) do |index,bin,print|
            words += bin
          end

          expect(words).to be == binary_words
        end
      end
    end

    it "must return the number of bytes read" do
      length = 100
      data   = 'A' * length

      expect(subject.each(data) { |index,hex,print| }).to be == length
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#dump" do
    it "should check if the output supports the '#<<' method" do
      expect {
        subject.dump(data,Object.new)
      }.to raise_error(ArgumentError)
    end

    let(:index_format) { "%.8x" }

    it "should append each line of the hexdump to the output" do
      lines = []

      subject.dump(data,lines)

      expect(lines.length).to be(2)
      expect(lines[0]).to start_with(index_format % 0)
      expect(lines[0]).to include(hex_chars.join(' '))
      expect(lines[0]).to end_with("|#{print_chars.join}|#{$/}")
    end

    it "must always print the total number of bytes read on the last line" do
      lines = []

      subject.dump(data,lines)

      expect(lines.last).to start_with(index_format % data.length)
    end
  end
end
