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

    it "must initialize #numeric to a Hexdump::Numeric::Hexadecimal" do
      expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Hexadecimal)
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

        it "must initialize #numeric to Hexdump::Numeric::CharOrInt" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::CharOrInt)
        end

        it "must set #char_map to nil" do
          expect(subject.char_map).to be(nil)
        end
      end

      context "when with type: is :uchar" do
        let(:type) { :uchar }

        it "must initialize #numeric to Hexdump::Numeric::CharOrInt" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::CharOrInt)
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
            }.to raise_error(Hexdump::Numeric::IncompatibleTypeError)
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

        it "must initialize #index to Hexdump::Numeric::Hexdecimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Hexadecimal)
        end

        it "must initialize #numeric to Hexdump::Numeric::Hexdecimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Hexadecimal)
        end
      end

      context "when the base: is 10" do
        let(:base) { 10 }

        it "must initialize #index to Hexdump::Numeric::Decimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Decimal)
        end

        it "must initialize #numeric to Hexdump::Numeric::Decimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Decimal)
        end
      end

      context "when given base: 8" do
        let(:base) { 8 }

        it "must initialize #index to Hexdump::Numeric::Octal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Octal)
        end

        it "must initialize #numeric to Hexdump::Numeric::Octal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Octal)
        end
      end

      context "when given base: 2" do
        let(:base) { 2 }

        it "must initialize #index to Hexdump::Numeric::Binary" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Binary)
        end

        it "must initialize #numeric to Hexdump::Numeric::Binary" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Binary)
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

  describe "#each_row" do
    let(:rows) do
      [
        Array.new(subject.columns, 0x41),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x43)
      ]
    end
    let(:data) do
      rows.map { |row| row.map(&:chr).join }.join
    end

    it "must yield each row of read values" do
      yielded_rows = []

      subject.each_row(data) do |row|
        yielded_rows << row
      end

      expect(yielded_rows).to eq(rows)
    end

    context "when the data's length is not evenly divisble by the columns" do
      let(:rows) do
        [
          Array.new(subject.columns, 0x41),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns / 2, 0x43)
        ]
      end

      it "must yield a partial row of read values last" do
        yielded_rows = []

        subject.each_row(data) do |row|
          yielded_rows << row
        end

        expect(yielded_rows).to eq(rows)
      end
    end

    context "when initialized with a custom columns: value" do
      let(:columns) { 7 }

      subject { described_class.new(columns: columns) }

      it "must yield rows with the same number of columns" do
        yielded_row_lengths = []

        subject.each_row(data) do |row|
          yielded_row_lengths << row.length
        end

        expect(yielded_row_lengths).to all(eq(columns))
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_row_with_index" do
    let(:rows) do
      [
        Array.new(subject.columns, 0x41),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x43)
      ]
    end
    let(:data) do
      rows.map { |row| row.map(&:chr).join }.join
    end

    it "must yield each row with an index for how many bytes have been read" do
      yielded_indices = []
      yielded_rows    = []

      subject.each_row_with_index(data) do |index,row|
        yielded_indices << index
        yielded_rows    << row
      end

      expect(yielded_indices).to eq(
        [
          0,
          rows[0].length,
          rows[0].length + rows[1].length
        ]
      )
      expect(yielded_rows).to eq(rows)
    end

    it "must return the total number of bytes read" do
      index = subject.each_row_with_index(data) do |index,row|
      end

      expect(index).to eq(data.length)
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_row_with_index(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_non_repeating_row" do
    let(:rows) do
      [
        Array.new(subject.columns, 0x41),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x43)
      ]
    end

    let(:data) do
      rows.map { |row| row.map(&:chr).join }.join
    end

    it "must omit repeating rows, instead yielding an index of '*'" do
      yielded_indices = []
      yielded_rows    = []

      subject.each_non_repeating_row(data) do |index,row|
        yielded_indices << index
        yielded_rows    << row
      end

      expect(yielded_indices).to eq(
        [
          0,
          rows[0].length,
          '*',
          rows[0].length + rows[1].length + rows[2].length + rows[3].length
        ]
      )

      expect(yielded_rows).to eq(
        [
          rows[0],
          rows[1],
          nil,
          rows[4]
        ]
      )
    end

    it "must return the total number of bytes read" do
      index = subject.each_non_repeating_row(data) do |index,row|
      end

      expect(index).to eq(data.length)
    end

    context "when the repeating rows is at the end of the data" do
      let(:rows) do
        [
          Array.new(subject.columns, 0x41),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns, 0x43),
          Array.new(subject.columns, 0x43),
          Array.new(subject.columns, 0x43)
        ]
      end

      it "must yield an index of '*' at the end" do
        yielded_indices = []
        yielded_rows    = []

        subject.each_non_repeating_row(data) do |index,row|
          yielded_indices << index
          yielded_rows    << row
        end

        expect(yielded_indices).to eq(
          [
            0,
            rows[0].length,
            rows[0].length + rows[1].length,
            '*'
          ]
        )

        expect(yielded_rows).to eq(
          [
            rows[0],
            rows[1],
            rows[2],
            nil
          ]
        )
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_non_repeating_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_formatted_row" do
    let(:rows) do
      [
        Array.new(subject.columns, 0x41),
        Array.new(subject.columns, 0x42),
        Array.new(subject.columns, 0x43)
      ]
    end

    let(:data) do
      rows.map { |row| row.map(&:chr).join }.join
    end

    let(:numeric_rows) do
      rows.map do |row|
        row.map { |b| subject.numeric % b }
      end
    end

    let(:char_rows) do
      rows.map do |row|
        row.map { |b| subject.char_map[b] }
      end
    end

    it "should yield the formatted indices to the given block" do
      yielded_indices = []

      subject.each_formatted_row(data) do |index,numeric,chars|
        yielded_indices << index
      end

      expect(yielded_indices).to eq(
        [
          subject.index % 0,
          subject.index % rows[0].length,
          subject.index % (rows[0].length + rows[1].length)
        ]
      )
    end

    it "should yield Arrays of numeric formatted values to the given block" do
      yielded_numeric_rows = []

      subject.each_formatted_row(data) do |index,numeric,chars|
        yielded_numeric_rows << numeric
      end

      expect(yielded_numeric_rows).to eq(numeric_rows)
    end

    it "should yield Arrays of mapped characters to the given block" do
      yielded_char_rows = []

      subject.each_formatted_row(data) do |index,numeric,chars|
        yielded_char_rows << chars
      end

      expect(yielded_char_rows).to eq(char_rows)
    end

    it "must return the total number of bytes read" do
      index = subject.each_formatted_row(data) do |index,numeric,chars|
      end

      expect(index).to eq(subject.index % data.length)
    end

    context "when the data's length is not evenly divisble by the columns" do
      let(:rows) do
        [
          Array.new(subject.columns, 0x41),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns / 2, 0x43)
        ]
      end

      it "must yield the partial Array of numeric formatted values last" do
        last_yielded_numeric = nil

        subject.each_formatted_row(data) do |index,numeric,chars|
          last_yielded_numeric = numeric
        end

        expect(last_yielded_numeric).to eq(numeric_rows.last)
      end

      it "must yield the partial Array of mapped characters values last" do
        last_yielded_chars = nil

        subject.each_formatted_row(data) do |index,numeric,chars|
          last_yielded_chars = chars
        end

        expect(last_yielded_chars).to eq(char_rows.last)
      end
    end

    context "when there is repeating rows of data" do
      let(:rows) do
        [
          Array.new(subject.columns, 0x41),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns, 0x42),
          Array.new(subject.columns, 0x43)
        ]
      end

      let(:numeric_rows) { super.uniq }
      let(:char_rows)    { super.uniq }

      it "should yield a '*' index to denote the beginning of repeating rows" do
        yielded_indices = []

        subject.each_formatted_row(data) do |index,numeric,chars|
          yielded_indices << index
        end

        expect(yielded_indices).to be == [
          subject.index % 0,
          subject.index % rows[0].length,
          '*',
          subject.index % (rows[0].length + rows[1].length + rows[2].length + rows[3].length)
        ]
      end
    end

    context "when initialized with a custom columns:" do
      let(:columns) { 7 }

      subject { described_class.new(columns: columns) }

      it "should yield rows with the same number of formatted columns" do
        rows = [
          'A' * subject.columns,
          'B' * subject.columns,
          'C' * subject.columns
        ]
        data = rows.join

        yielded_numeric_lengths = []
        yielded_chars_lengths   = []

        subject.each_formatted_row(data) do |index,numeric,chars|
          yielded_numeric_lengths << numeric.length
          yielded_chars_lengths   << chars.length
        end

        expect(yielded_numeric_lengths).to all(eq(columns))
        expect(yielded_chars_lengths).to   all(eq(columns))
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

        subject.each_formatted_row(leading + string) do |index,hex,print|
          remainder = print
        end

        expect(remainder).to be == chars
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_formatted_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#print" do
    context "when given an output that does not support #print" do
      let(:output) { Object.new }

      it do
        expect {
          subject.print(data, output: output)
        }.to raise_error(ArgumentError,"output must support the #print method")
      end
    end

    let(:output) { StringIO.new }
    let(:lines)  { output.string.lines }

    let(:index_format) { "%.8x" }

    it "must append each line of the hexdump to the output" do
      subject.print(data, output: output)

      expect(lines.length).to be(2)
      expect(lines[0]).to start_with(index_format % 0)
      expect(lines[0]).to include(hex_chars.join(' '))
      expect(lines[0]).to end_with("|#{print_chars.join}|#{$/}")
    end

    it "must always print the total number of bytes read on the last line" do
      subject.print(data, output: output)

      expect(lines.last).to start_with(index_format % data.length)
    end
  end
end
