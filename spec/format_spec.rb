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

    it "must default #group_columns to nil" do
      expect(subject.group_columns).to be(nil)
    end

    it "must default #base to 16" do
      expect(subject.base).to eq(16)
    end

    it "must initialize #index to Hexdump::Numeric::Hexdecimal by default" do
      expect(subject.index).to be_kind_of(Hexdump::Numeric::Hexadecimal)
    end

    it "must default #encoding to nil" do
      expect(subject.encoding).to be(nil)
    end

    it "must initialize #numeric to a Hexdump::Numeric::Hexadecimal" do
      expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Hexadecimal)
    end

    it "must initialize the #reader with zero-padding disabled by default" do
      expect(subject.reader.zero_pad?).to be(false)
    end

    context "when given zero_pad: true" do
      subject { described_class.new(zero_pad: true) }

      it "must initialize the #reader with zero-padding enabled" do
        expect(subject.reader.zero_pad?).to be(true)
      end
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

        it "must set #type to Hexdump::Type::Char" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Char)
        end

        it "must initialize #numeric to Hexdump::Numeric::CharOrInt" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::CharOrInt)
        end

        it "must disable #chars" do
          expect(subject.chars).to be(false)
        end
      end

      context "when with type: is :uchar" do
        let(:type) { :uchar }

        it "must initialize #numeric to Hexdump::Numeric::CharOrInt" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::CharOrInt)
        end
      end

      context "when the type: is :byte" do
        let(:type) { :byte }

        it "must set #type to Hexdump::Type::UInt8" do
          expect(subject.type).to be_kind_of(Hexdump::Type::UInt8)
        end
      end

      context "when the type: is :uint8" do
        let(:type) { :uint8 }

        it "must set #type to Hexdump::Type::UInt8" do
          expect(subject.type).to be_kind_of(Hexdump::Type::UInt8)
        end
      end

      context "when the type: is :int8" do
        let(:type) { :int8 }

        it "must set #type to Hexdump::Type::Int8" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Int8)
        end
      end

      context "when the type: is :uint16" do
        let(:type) { :uint16 }

        it "must set #type to Hexdump::Type::UInt16" do
          expect(subject.type).to be_kind_of(Hexdump::Type::UInt16)
        end
      end

      context "when the type: is :int16" do
        let(:type) { :int16 }

        it "must set #type to Hexdump::Type::Int16" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Int16)
        end
      end

      context "when the type: is :uint32" do
        let(:type) { :uint32 }

        it "must set #type to Hexdump::Type::UInt32" do
          expect(subject.type).to be_kind_of(Hexdump::Type::UInt32)
        end
      end

      context "when the type: is :int32" do
        let(:type) { :int32 }

        it "must set #type to Hexdump::Type::Int32" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Int32)
        end
      end

      context "when the type: is :uint64" do
        let(:type) { :uint64 }

        it "must set #type to Hexdump::Type::UInt64" do
          expect(subject.type).to be_kind_of(Hexdump::Type::UInt64)
        end
      end

      context "when the type: is :int64" do
        let(:type) { :int64 }

        it "must set #type to Hexdump::Type::Int64" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Int64)
        end
      end

      context "and the type is :float, :float32, :float64, or :double" do
        let(:type) { :float }

        it "must set #type to Hexdump::Type::Float" do
          expect(subject.type).to be_kind_of(Hexdump::Type::Float)
        end

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

        it "must initialize #numeric to Hexdump::Numeric::Hexdecimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Hexadecimal)
        end
      end

      context "when the base: is 10" do
        let(:base) { 10 }

        it "must initialize #numeric to Hexdump::Numeric::Decimal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Decimal)
        end
      end

      context "when given base: 8" do
        let(:base) { 8 }

        it "must initialize #numeric to Hexdump::Numeric::Octal" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Octal)
        end
      end

      context "when given base: 2" do
        let(:base) { 2 }

        it "must initialize #numeric to Hexdump::Numeric::Binary" do
          expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Binary)
        end
      end
    end

    context "when given index: keyword" do
      subject { described_class.new(index: index) }

      context "when the index: is 16" do
        let(:index) { 16 }

        it "must initialize #index to Hexdump::Numeric::Hexdecimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Hexadecimal)
        end
      end

      context "when the index: is 10" do
        let(:index) { 10 }

        it "must initialize #index to Hexdump::Numeric::Decimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Decimal)
        end
      end

      context "when given index: 8" do
        let(:index) { 8 }

        it "must initialize #index to Hexdump::Numeric::Octal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Octal)
        end
      end

      context "when given index: 2" do
        let(:index) { 2 }

        it "must initialize #index to Hexdump::Numeric::Binary" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Binary)
        end
      end
    end

    context "when given the columns: keyword" do
      let(:columns) { 7 }

      subject { described_class.new(columns: columns) }

      it "must set #columns" do
        expect(subject.columns).to eq(columns)
      end
    end

    context "when given the group_columns: keyword" do
      let(:group_columns) { 4 }

      subject { described_class.new(group_columns: group_columns) }

      it "must set #group_columns" do
        expect(subject.group_columns).to eq(group_columns)
      end
    end

    context "when given the encoding: keyword" do
      context "and it is :ascii" do
        subject { described_class.new(encoding: :ascii) }

        it "must set #encoding to nil" do
          expect(subject.encoding).to be(nil)
        end
      end

      context "and it is :utf8" do
        subject { described_class.new(encoding: :utf8) }

        it "must set #encoding to Encoding::UTF_8" do
          expect(subject.encoding).to be(Encoding::UTF_8)
        end
      end

      context "and is nil" do
        subject { described_class.new(encoding: nil) }

        it "must set #encoding to nil" do
          expect(subject.encoding).to be(nil)
        end
      end

      context "and is an Encoding object" do
        let(:encoding) { Encoding::UTF_7 }

        subject { described_class.new(encoding: nil) }

        it "must set #encoding" do
          expect(subject.encoding).to be(nil)
        end
      end

      context "otherwise" do
        it "must raise an ArgumentError" do
          expect {
            described_class.new(encoding: Object.new)
          }.to raise_error(ArgumentError,"encoding must be :ascii, :utf8 or an Encoding object")
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

  let(:data) do
    'A' * subject.columns + \
    'B' * subject.columns + \
    'C' * subject.columns
  end

  let(:columns) { subject.columns }

  let(:rows) do
    [
      [columns * 0, [0x41] * columns, ['A'] * columns],
      [columns * 1, [0x42] * columns, ['B'] * columns],
      [columns * 2, [0x43] * columns, ['C'] * columns],
    ]
  end

  describe "#each_row" do
    it "must yield each row of index, numeric values, and raw characters" do
      yielded_rows = []

      subject.each_row(data) do |*args|
        yielded_rows << args
      end

      expect(yielded_rows).to eq(rows)
    end

    it "must return the total number of bytes read" do
      index = subject.each_row(data) do |*args|
      end

      expect(index).to eq(data.length)
    end

    context "when the data's length is not evenly divisble by the columns" do
      let(:rows) do
        [
          [columns * 0, [0x41] * columns,       ['A'] * columns      ],
          [columns * 1, [0x42] * columns,       ['B'] * columns      ],
          [columns * 2, [0x43] * (columns / 2), ['C'] * (columns / 2)]
        ]
      end

      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'C' * (columns / 2)
      end

      it "must yield a partial row of read values last" do
        yielded_rows = []

        subject.each_row(data) do |*args|
          yielded_rows << args
        end

        expect(yielded_rows).to eq(rows)
      end
    end

    context "when initialized with a custom columns: value" do
      let(:columns) { 7 }

      subject { described_class.new(columns: columns) }

      it "must yield rows with the same number of columns" do
        yielded_row_lengths = []

        subject.each_row(data) do |index,numeric,chars|
          yielded_row_lengths << numeric.length
        end

        expect(yielded_row_lengths).to all(eq(columns))
      end
    end

    context "when there are not enough bytes to decode the last value" do
      subject { described_class.new(type: :uint32) }

      let(:size) { subject.type.size }

      let(:data) do
        "\x41\x41\x41\x41" * columns + \
        "ABC"
      end

      let(:rows) do
        [
          [size * columns * 0, [0x41414141] * columns, ["AAAA"] * columns],
          [size * columns * 1, [nil], ["ABC"]]
        ]
      end

      it "must yield the read characters, but not the partially decoded value" do
        yielded_rows = []

        subject.each_row(data) do |*row|
          yielded_rows << row
        end

        expect(yielded_rows).to eq(rows)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_non_repeating_row" do
    let(:rows) do
      [
        [columns * 0, [0x41] * columns, ['A'] * columns],
        [columns * 1, [0x42] * columns, ['B'] * columns],
        ['*'                                         ],
        [columns * 4, [0x43] * columns, ['C'] * columns]
      ]
    end

    let(:data) do
      'A' * subject.columns + \
      'B' * subject.columns + \
      'B' * subject.columns + \
      'B' * subject.columns + \
      'C' * subject.columns
    end

    it "must omit repeating rows, instead yielding an index of '*'" do
      yielded_rows = []

      subject.each_non_repeating_row(data) do |*args|
        yielded_rows << args
      end

      expect(yielded_rows).to eq(rows)
    end

    it "must return the total number of bytes read" do
      index = subject.each_non_repeating_row(data) do |*args|
      end

      expect(index).to eq(data.length)
    end

    context "when the repeating rows is at the end of the data" do
      let(:rows) do
        [
          [columns * 0, [0x41] * columns, ['A'] * columns],
          [columns * 1, [0x42] * columns, ['B'] * columns],
          [columns * 2, [0x43] * columns, ['C'] * columns],
          ['*'                                           ]
        ]
      end

      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'C' * columns + \
        'C' * columns + \
        'C' * columns
      end

      it "must yield an index of '*' at the end" do
        yielded_rows = []

        subject.each_non_repeating_row(data) do |*args|
          yielded_rows << args
        end

        expect(yielded_rows).to eq(rows)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_non_repeating_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_formatted_row" do
    let(:formatted_rows) do
      rows.map do |row|
        if row[0] == '*'
          ['*']
        else
          [
            subject.index % row[0],
            row[1].map { |value| subject.numeric % value if value },
            row[2].join.gsub(/[^[:print:]]/,'.')
          ]
        end
      end
    end

    it "should yield the formatted rows to the given block" do
      yielded_rows = []

      subject.each_formatted_row(data) do |*row|
        yielded_rows << row
      end

      expect(yielded_rows).to eq(formatted_rows)
    end

    it "must return the formatted total number of bytes read" do
      index = subject.each_formatted_row(data) do |*row|
      end

      expect(index).to eq(subject.index % data.length)
    end

    [*(0x00..0x20), *(0x7f..0xff)].each do |byte|
      context "when the row contains an ASCII #{byte.chr.dump} characters" do
        let(:row) do
          [
            [columns * 0, [0x41, 0x42, 0x43, byte], ['A', 'B', 'C', '.']]
          ]
        end

        it "must replace unprintable characters with a '.'" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end
    end

    context "when the data's length is not evenly divisble by the columns" do
      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'C' * (columns / 2)
      end

      let(:rows) do
        [
          [columns * 0, [0x41] * columns,       ['A'] * columns      ],
          [columns * 1, [0x42] * columns,       ['B'] * columns      ],
          [columns * 2, [0x43] * (columns / 2), ['C'] * (columns / 2)]
        ]
      end

      it "must yield the last formatted partial row" do
        yielded_rows = []

        subject.each_formatted_row(data) do |*row|
          yielded_rows << row
        end

        expect(yielded_rows).to eq(formatted_rows)
      end
    end

    context "when there are not enough bytes to decode the last value" do
      subject { described_class.new(type: :uint32) }

      let(:size) { subject.type.size }

      let(:data) do
        "\x41\x41\x41\x41" * columns + \
        "ABC"
      end

      let(:rows) do
        [
          [size * columns * 0, [0x41414141] * columns, ["AAAA"] * columns],
          [size * columns * 1, [nil], ["ABC"]]
        ]
      end

      it "must yield the read characters, but not the partially decoded value" do
        yielded_rows = []

        subject.each_formatted_row(data) do |*row|
          yielded_rows << row
        end

        expect(yielded_rows).to eq(formatted_rows)
      end
    end

    context "when there is repeating rows of data" do
      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'B' * columns + \
        'B' * columns + \
        'C' * columns
      end

      let(:rows) do
        [
          [columns * 0, [0x41] * columns, ['A'] * columns],
          [columns * 1, [0x42] * columns, ['B'] * columns],
          ['*'                                         ],
          [columns * 4, [0x43] * columns, ['C'] * columns]
        ]
      end

      it "must yield the formatted rows and a '*' row to denote the beginning of repeating rows" do
        yielded_rows = []

        subject.each_formatted_row(data) do |*row|
          yielded_rows << row
        end

        expect(yielded_rows).to eq(formatted_rows)
      end

      context "and #repeating is true" do
        subject { described_class.new(repeating: true) }

        let(:rows) do
          [
            [columns * 0, [0x41] * columns, ['A'] * columns],
            [columns * 1, [0x42] * columns, ['B'] * columns],
            [columns * 2, [0x42] * columns, ['B'] * columns],
            [columns * 3, [0x42] * columns, ['B'] * columns],
            [columns * 4, [0x43] * columns, ['C'] * columns]
          ]
        end

        it "must yield the formatted repeating rows" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end
    end

    context "when initialized with a custom columns:" do
      let(:columns) { 7 }

      subject { described_class.new(columns: columns) }

      it "must yield rows with the same number of formatted columns" do
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

    context "when #encoding is set" do
      let(:encoding) { Encoding::UTF_8 }

      subject { described_class.new(encoding: encoding) }

      it "must encode the characters to the given Encoding" do
        yielded_char_encodings = []

        subject.each_formatted_row(data) do |index,numeric,chars|
          yielded_char_encodings << chars.encoding
        end

        expect(yielded_char_encodings).to all(eq(encoding))
      end

      context "and the data contains unprintable characters" do
        let(:codepoint) { 888 }
        let(:char) { codepoint.chr(encoding) }
        let(:data) { "A#{char}B" }

        let(:formatted_rows) do
          [
            [subject.index % 0, ["41", "cd", "b8", "42"], "A.B"]
          ]
        end

        it "must replace any unprintable characters with a '.'" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "and the data contains invalid byte sequences" do
        let(:invalid_bytes) { "\x80\x81" }
        let(:data) { "A#{invalid_bytes}B" }

        let(:formatted_rows) do
          [
            [subject.index % 0, ["41", "80", "81", "42"], "A..B"]
          ]
        end

        it "must replace any invalid byte sequences with a '.'" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_formatted_row(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#print" do
    let(:output) { StringIO.new }
    let(:lines)  { output.string.lines }

    let(:index_format) { "%.8x" }

    it "must append each line of the hexdump to the output" do
      expected_lines = subject.each_line(data).to_a

      subject.print(data, output: output)

      expect(lines.length).to eq(rows.length + 1)
      expect(lines).to eq(expected_lines)
    end

    it "must always print the total number of bytes read on the last line" do
      subject.print(data, output: output)

      expect(lines.last).to start_with(index_format % data.length)
    end

    context "when given an output that does not support #print" do
      let(:output) { Object.new }

      it do
        expect {
          subject.print(data, output: output)
        }.to raise_error(ArgumentError,"output must support the #print method")
      end
    end
  end
end
