require 'spec_helper'
require 'hexdump/format'

describe Hexdump::Format do
  let(:bytes)         { [104, 101, 108, 108, 111] }
  let(:hex_chars)     { %w[68 65 6c 6c 6f] }
  let(:decimal_chars) { %w[104 101 108 108 111] }
  let(:octal_chars)   { %w[150 145 154 154 157] }
  let(:binary_chars)  { %w[01101000 01100101 01101100 01101100 01101111] }
  let(:print_chars)   { %w[h e l l o] }
  let(:data)          { print_chars.join }

  describe "#initialize" do
    it "must default type to :byte" do
      expect(subject.type).to be(Hexdump::TYPES[:byte])
    end

    it "must default #columns to 16" do
      expect(subject.columns).to eq(16)
    end

    it "must default #base to 16" do
      expect(subject.base).to eq(16)
    end

    it "must initialize #numeric to a Hexdump::Numeric::Base::Hexadecimal" do
      expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Hexadecimal)
    end

    context "when given a type: keyword" do
      let(:type) { :uint16_le }

      subject { described_class.new(type: type) }

      it "must look up the given type in Hexdump::TYPES" do
        expect(subject.type).to be(Hexdump::TYPES[type])
      end

      it "must divide the number of columns by the size of the type" do
        expect(subject.columns).to eq(16 / Hexdump::TYPES[type].size)
      end

      context "when initialized with a type: :char" do
        subject { described_class.new(type: :char) }

        it "must initialize #numeric to Hexdump::Numeric::Chars" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Chars)
        end

        it "must set #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when with type: is :uchar" do
        let(:type) { :uchar }

        it "must initialize #numeric to Hexdump::Numeric::Chars" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Chars)
        end

        it "must set #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when the type: is :byte" do
        let(:type) { :byte }

        it "must initialize #char_map to Hexdump::CharMap::ASCII" do
          expect(subject.char_map).to be(Hexdump::CharMap::ASCII)
        end
      end

      context "when the type: is :uint8" do
        let(:type) { :uint8 }

        it "must initialize #char_map to Hexdump::CharMap::ASCII" do
          expect(subject.char_map).to be(Hexdump::CharMap::ASCII)
        end
      end

      context "when the type: is :int8" do
        let(:type) { :int8 }

        it "must initialize #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when the type: is :uint16" do
        let(:type) { :uint16 }

        it "must initialize #char_map to Hexdump::CharMap::UTF8" do
          expect(subject.char_map).to be(Hexdump::CharMap::UTF8)
        end
      end

      context "when the type: is :int16" do
        let(:type) { :int16 }

        it "must initialize #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when the type: is :uint32" do
        let(:type) { :uint32 }

        it "must initialize #char_map to Hexdump::CharMap::UTF8" do
          expect(subject.char_map).to be(Hexdump::CharMap::UTF8)
        end
      end

      context "when the type: is :int32" do
        let(:type) { :int32 }

        it "must initialize #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when the type: is :uint64" do
        let(:type) { :uint64 }

        it "must initialize #char_map to Hexdump::CharMap::UTF8" do
          expect(subject.char_map).to be(Hexdump::CharMap::UTF8)
        end
      end

      context "when the type: is :int64" do
        let(:type) { :int64 }

        it "must initialize #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "and the type is :float, :float32, :float64, or :double" do
        let(:type) { :float }

        it "must default the #base to 10" do
          expect(subject.base).to eq(10)
        end

        context "but the base: value isn't 10 or 16" do
          it do
            expect {
              described_class.new(type: type, base: 8)
            }.to raise_error(Hexdump::Numeric::Base::IncompatibleTypeError)
          end
        end
      end

      context "when given an unsupported type" do
        it do
          expect {
            described_class.new(type: :foo)
          }.to raise_error(ArgumentError,"unsupported type: :foo")
        end
      end
    end

    context "when given base: keyword" do
      subject { described_class.new(base: base) }

      context "when the base: is 16" do
        let(:base) { 16 }

        it "must initialize #numeric to Hexdump::Numeric::Base::Hexdecimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Hexadecimal)
        end
      end

      context "when the base: is 10" do
        let(:base) { 10 }

        it "must initialize #numeric to Hexdump::Numeric::Base::Decimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Decimal)
        end
      end

      context "when given base: 8" do
        let(:base) { 8 }

        it "must initialize #numeric to Hexdump::Numeric::Base::Octal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Octal)
        end
      end

      context "when given base: 2" do
        let(:base) { 2 }

        it "must initialize #numeric to Hexdump::Numeric::Base::Binary" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Binary)
        end
      end
    end

    context "when given an unsupported base: value" do
      it do
        expect {
          described_class.new(base: 3)
        }.to raise_error(ArgumentError,"unsupported base: 3")
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
      let(:columns) { 10 }

      subject { described_class.new(columns: columns) }

      it "should change the columns, in bytes, of each line" do
        columnss = []
        count  = 10

        subject.each('A' * (columns * count)) do |index,hex,print|
          columnss << hex.length
        end

        expect(columnss).to be == ([columns] * count)
      end
    end

    context "when there are leftover bytes" do
      let(:columns) { 10 }

      subject { described_class.new(columns: columns) }

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

    context "when initialized with base: 10" do
      subject { described_class.new(base: 10) }

      it "should support dumping bytes in decimal format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == decimal_chars
      end
    end

    context "when initialized with base: 8" do
      subject { described_class.new(base: 8) }

      it "should support dumping bytes in octal format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == octal_chars
      end
    end

    context "when initialized with base: 2" do
      subject { described_class.new(base: 2) }

      it "should support dumping bytes in binary format" do
        chars = []

        subject.each(data) do |index,hex,print|
          chars += hex
        end

        expect(chars).to be == binary_chars
      end
    end

    context "when type has a size > 1 and endian-ness" do
      let(:type)      { :uint16_le         }
      let(:hex_words) { %w[6568 6c6c 006f] }

      subject { described_class.new(type: type) }

      it "should dump words in hexadecimal by default" do
        words = []

        subject.each(data) do |index,hex,print|
          words += hex
        end

        expect(words).to be == hex_words
      end

      context "and base: 10" do
        subject { described_class.new(type: type, base: 10) }

        let(:decimal_words) { ['25960', '27756', '  111'] }

        it "should dump words in decimal" do
          words = []

          subject.each(data) do |index,dec,print|
            words += dec
          end

          expect(words).to be == decimal_words
        end
      end

      context "and base: 8" do
        subject { described_class.new(type: type, base: 8) }

        let(:octal_words) { %w[062550 066154 000157] }

        it "should dump words in octal" do
          words = []

          subject.each(data) do |index,oct,print|
            words += oct
          end

          expect(words).to be == octal_words
        end
      end

      context "and base: 2" do
        subject { described_class.new(type: type, base: 2) }

        let(:binary_words) { %w[0110010101101000 0110110001101100 0000000001101111] }

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

  describe "#print" do
    context "when given an output that does not support #print" do
      let(:output) { Object.new }

      it do
        expect {
          subject.print(data,output)
        }.to raise_error(ArgumentError,"output must support the #print method")
      end
    end

    let(:output) { StringIO.new }
    let(:lines)  { output.string.lines }

    let(:index_format) { "%.8x" }

    it "must append each line of the hexdump to the output" do
      subject.print(data,output)

      expect(lines.length).to be(2)
      expect(lines[0]).to start_with(index_format % 0)
      expect(lines[0]).to include(hex_chars.join(' '))
      expect(lines[0]).to end_with("|#{print_chars.join}|#{$/}")
    end

    it "must always print the total number of bytes read on the last line" do
      subject.print(data,output)

      expect(lines.last).to start_with(index_format % data.length)
    end
  end
end
