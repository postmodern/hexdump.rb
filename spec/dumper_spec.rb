require 'spec_helper'
require 'hexdump/dumper'

describe Hexdump::Dumper do
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

    context "when given a custom type name" do
      let(:type) { :uint16_le }

      subject { described_class.new(type: type) }

      it "must look up the given type in Hexdump::TYPES" do
        expect(subject.type).to be(Hexdump::TYPES[type])
      end

      it "must divide the number of columns by the size of the type" do
        expect(subject.columns).to eq(16 / Hexdump::TYPES[type].size)
      end

      context "and the type is of a Type::Float type" do
        let(:type) { :float }

        it "must default the #base to 10" do
          expect(subject.base).to eq(10)
        end

        context "but the base: value isn't 10 or 16" do
          it do
            expect {
              described_class.new(type: type, base: 8)
            }.to raise_error(TypeError)
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

    context "when given an unsupported base: value" do
      it do
        expect {
          described_class.new(base: 3)
        }.to raise_error(ArgumentError,"unsupported base: 3")
      end
    end
  end

  describe "#numeric" do
    it do
      expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Base::Hexadecimal)
    end

    it "must map numeric values to their hex String representations" do
      expect(subject.numeric % 0xff).to eq("ff")
    end

    context "when initialized with base: 10" do
      subject { described_class.new(base: 10) }

      it "must return numeric Strings in base 10" do
        expect(subject.numeric % 0xff).to eq("255")
      end
    end

    context "when initialized with base: 8" do
      subject { described_class.new(base: 8) }

      it "must return numeric Strings in base 8" do
        expect(subject.numeric % 0xff).to eq("377")
      end
    end

    context "when initialized with base: 2" do
      subject { described_class.new(base: 2) }

      it "must return numeric Strings in base 2" do
        expect(subject.numeric % 0xff).to eq("11111111")
      end
    end

    context "when initialized with type: :char" do
      subject { described_class.new(type: :char) }

      it do
        expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Chars)
        expect(subject.numeric.base).to be_kind_of(Hexdump::Numeric::Base::Decimal)
      end

      context "when given a value that maps to a printable character" do
        it "must return the printable character with left-padding" do
          expect(subject.numeric % 0x41).to eq("  A")
        end
      end

      context "when given a value that does not map to a printable character" do
        it "must return the hex String representation, with left-padding" do
          expect(subject.numeric % 0xff).to eq(" 255")
        end
      end

      context "when given a negative value" do
        it "must return the hex String representation with a '-' character" do
          expect(subject.numeric % -0xff).to eq('-255')
        end
      end

      it "must map 0x00 to \\0" do
        expect(subject.numeric % 0x00).to eq(" \\0")
      end

      it "must map 0x07 to \\a" do
        expect(subject.numeric % 0x07).to eq(" \\a")
      end

      it "must map 0x08 to \\b" do
        expect(subject.numeric % 0x08).to eq(" \\b")
      end

      it "must map 0x09 to \\t" do
        expect(subject.numeric % 0x09).to eq(" \\t")
      end

      it "must map 0x0a to \\n" do
        expect(subject.numeric % 0x0a).to eq(" \\n")
      end

      it "must map 0x0b to \\v" do
        expect(subject.numeric % 0x0b).to eq(" \\v")
      end

      it "must map 0x0c to \\f" do
        expect(subject.numeric % 0x0c).to eq(" \\f")
      end

      it "must map 0x0d to \\r" do
        expect(subject.numeric % 0x0d).to eq(" \\r")
      end
    end

    context "when initialized with type: :uint16" do
      subject { described_class.new(type: :uint16) }

      it "must map numeric values to their numeric String representation" do
        expect(subject.numeric % 0x4241).to eq('4241')
      end

      context "when initialized with base: 10" do
        subject { described_class.new(base: 10) }

        it "must return numeric Strings in base 10" do
          expect(subject.numeric % 0xffff).to eq("65535")
        end
      end

      context "when initialized with base: 8" do
        subject { described_class.new(base: 8) }

        it "must return numeric Strings in base 8" do
          expect(subject.numeric % 0xffff).to eq("177777")
        end
      end

      context "when initialized with base: 2" do
        subject { described_class.new(base: 2) }

        it "must return numeric Strings in base 2" do
          expect(subject.numeric % 0xffff).to eq("1111111111111111")
        end
      end
    end

    context "when initialized with type: :int8" do
      subject { described_class.new(type: :int8) }

      context "when given a positive value" do
        it "must left-pad the value to accomodate for the missing '-'" do
          expect(subject.numeric % 0x41).to eq(" 41")
        end
      end

      context "when given a negative value" do
        it "must start with a '-' character" do
          expect(subject.numeric % -0x41).to eq("-41")
        end
      end

      context "when initialized with base: 10" do
        subject { described_class.new(type: :int8, base: 10) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xff).to eq(" 255")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xff).to eq("-255")
          end
        end
      end

      context "when initialized with base: 8" do
        subject { described_class.new(type: :int8, base: 8) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xff).to eq(" 377")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xff).to eq("-377")
          end
        end
      end

      context "when initialized with base: 2" do
        subject { described_class.new(type: :int8, base: 2) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xff).to eq(" 11111111")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xff).to eq("-11111111")
          end
        end
      end
    end

    context "when initialized with type: :int16 or greater" do
      subject { described_class.new(type: :int16) }

      context "when given a positive value" do
        it "must left-pad the value to accomodate for the missing '-'" do
          expect(subject.numeric % 0xffff).to eq(" ffff")
        end
      end

      context "when given a negative value" do
        it "must start with a '-' character" do
          expect(subject.numeric % -0xffff).to eq("-ffff")
        end
      end

      context "when initialized with base: 10" do
        subject { described_class.new(type: :int16_le, base: 10) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xffff).to eq(" 65535")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xffff).to eq("-65535")
          end
        end
      end

      context "when initialized with base: 8" do
        subject { described_class.new(type: :int16_le, base: 8) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xffff).to eq(" 177777")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xffff).to eq("-177777")
          end
        end
      end

      context "when initialized with base: 2" do
        subject { described_class.new(type: :int16_le, base: 2) }

        context "when given a positive value" do
          it "must return numeric Strings in base 10, with left-padding" do
            expect(subject.numeric % 0xffff).to eq(" 1111111111111111")
          end
        end

        context "when given a negative value" do
          it "must return numeric Strings in base 10, with a '-' character" do
            expect(subject.numeric % -0xffff).to eq("-1111111111111111")
          end
        end
      end
    end
  end

  describe "#char_map" do
    context "when initialized with a type: :char" do
      subject { described_class.new(type: :char) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :uchar" do
      subject { described_class.new(type: :uchar) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :uint8" do
      subject { described_class.new(type: :uint8) }

      it do
        expect(subject.char_map).to be(Hexdump::CharMap::ASCII)
      end

      it "must map numeric values to characters character Strings" do
        expect(subject.char_map[0x41]).to eq("A")
      end

      context "when given a value that does not map to a characters char" do
        it "must return '.'" do
          expect(subject.char_map[0xff]).to eq('.')
        end
      end
    end

    context "when initialized with a type: :uint16 or greater" do
      subject { described_class.new(type: :uint16_le) }

      it do
        expect(subject.char_map).to be(Hexdump::CharMap::UTF8)
      end

      context "when given a single byte value" do
        context "and it maps to a characters ASCII character" do
          it "must return the ASCII character" do
            expect(subject.char_map[0x41]).to eq("A")
          end
        end

        context "and it does not map to a characters ASCII character" do
          it "must return '.'" do
            expect(subject.char_map[0xff]).to eq('.')
          end
        end
      end

      context "when given a multi-byte value" do
        context "and it maps to a valid UTF character" do
          it "must return the UTF character" do
            expect(subject.char_map[0x4241]).to eq("䉁")
          end
        end

        context "but it does not map to a UTF character" do
          it "must return '.'" do
            expect(subject.char_map[0xd800]).to eq('.')
          end
        end
      end
    end

    context "when initialized with type: :int" do
      subject { described_class.new(type: :int) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :int8" do
      subject { described_class.new(type: :int8) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :int16" do
      subject { described_class.new(type: :int16) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :int32" do
      subject { described_class.new(type: :int32) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :int64" do
      subject { described_class.new(type: :int64) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :float" do
      subject { described_class.new(type: :float) }

      it { expect(subject.char_map).to be(nil) }
    end

    context "when initialized with type: :double" do
      subject { described_class.new(type: :double) }

      it { expect(subject.char_map).to be(nil) }
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
