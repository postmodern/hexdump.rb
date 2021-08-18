require 'spec_helper'
require 'hexdump/hexdump'

describe Hexdump::Hexdump do
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

    it "must default #offset to 0" do
      expect(subject.offset).to eq(0)
    end

    it "must initialize #numeric to a Hexdump::Numeric::Hexadecimal" do
      expect(subject.numeric).to be_kind_of(Hexdump::Numeric::Hexadecimal)
    end

    it "must initialize the #reader with zero-padding disabled by default" do
      expect(subject.reader.zero_pad?).to be(false)
    end

    it "must initialize #chars by default" do
      expect(subject.chars).to be_kind_of(Hexdump::Chars)
    end

    context "when given the chars: true" do
      subject { described_class.new(chars: true) }

      it "must default #chars.encoding to nil" do
        expect(subject.chars.encoding).to be(nil)
      end

      context "and encoding: keyword" do
        context "and it is :ascii" do
          subject { described_class.new(chars: true, encoding: :ascii) }

          it "must set #chars.encoding to nil" do
            expect(subject.chars.encoding).to be(nil)
          end
        end

        context "and it is :utf8" do
          subject { described_class.new(chars: true, encoding: :utf8) }

          it "must set #chars.encoding to Encoding::UTF_8" do
            expect(subject.chars.encoding).to be(Encoding::UTF_8)
          end
        end

        context "and is nil" do
          subject { described_class.new(chars: true, encoding: nil) }

          it "must set #encoding to nil" do
            expect(subject.chars.encoding).to be(nil)
          end
        end

        context "and is an Encoding object" do
          let(:encoding) { Encoding::UTF_7 }

          subject { described_class.new(chars: true, encoding: nil) }

          it "must set #encoding" do
            expect(subject.chars.encoding).to be(nil)
          end
        end

        context "otherwise" do
          it "must raise an ArgumentError" do
            expect {
              described_class.new(chars: true, encoding: Object.new)
            }.to raise_error(ArgumentError,"encoding must be nil, :ascii, :utf8, or an Encoding object")
          end
        end
      end
    end

    context "when given chars: false" do
      subject { described_class.new(chars: false) }

      it "must set #chars to nil" do
        expect(subject.chars).to be(nil)
      end
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
          expect(subject.chars).to be(nil)
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

    context "when given index_base: keyword" do
      subject { described_class.new(index_base: index_base) }

      context "when the index: is 16" do
        let(:index_base) { 16 }

        it "must initialize #index to Hexdump::Numeric::Hexdecimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Hexadecimal)
        end
      end

      context "when the index: is 10" do
        let(:index_base) { 10 }

        it "must initialize #index to Hexdump::Numeric::Decimal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Decimal)
        end
      end

      context "when given index: 8" do
        let(:index_base) { 8 }

        it "must initialize #index to Hexdump::Numeric::Octal" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Octal)
        end
      end

      context "when given index: 2" do
        let(:index_base) { 2 }

        it "must initialize #index to Hexdump::Numeric::Binary" do
          expect(subject.index).to be_kind_of(Hexdump::Numeric::Binary)
        end
      end
    end

    context "when given the offset: keyword" do
      let(:offset) { 1024 }

      subject { described_class.new(offset: offset) }

      it "must set #offset" do
        expect(subject.offset).to eq(offset)
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

    context "when given an unsupported base: value" do
      it do
        expect {
          described_class.new(base: 3)
        }.to raise_error(ArgumentError,"unsupported base: 3")
      end
    end

    it "must default #theme to nil" do
      expect(subject.theme).to be(nil)
    end

    context "when given theme: true" do
      subject { described_class.new(theme: true) }

      it "must initialize #theme" do
        expect(subject.theme).to be_kind_of(Hexdump::Theme)
      end
    end

    context "when given the style: keyword" do
      context "and is a Hash" do
        let(:index_style)   { :white }
        let(:numeric_style) { :cyan  }
        let(:chars_style)   { :blue  }

        subject do
          described_class.new(
            style: {
              index:   index_style,
              numeric: numeric_style,
              chars:   chars_style
            }
          )
        end

        it "must initialize #style" do
          expect(subject.theme).to be_kind_of(Hexdump::Theme)
        end

        it "must initialize #style.index" do
          expect(subject.theme.index).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.index.theme" do
          expect(subject.theme.index.style.parameters).to eq(index_style)
        end

        it "must initialize #style.numeric" do
          expect(subject.theme.numeric).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.numeric.theme" do
          expect(subject.theme.numeric.style.parameters).to eq(numeric_style)
        end

        it "must initialize #style.chars" do
          expect(subject.theme.chars).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.chars.theme" do
          expect(subject.theme.chars.style.parameters).to eq(chars_style)
        end
      end
    end

    context "when given the highlights: keyword" do
      context "and is a Hash" do
        let(:index_pattern)      { /00$/ }
        let(:index_highlight)    { :white }
        let(:index_highlights)   { {index_pattern => index_highlight} }

        let(:numeric_pattern)    { '00'    }
        let(:numeric_highlight)  { :faint  }
        let(:numeric_highlights) { {numeric_pattern => numeric_highlight}  }

        let(:chars_pattern)    { /A-Z/  }
        let(:chars_highlight)  { :bold  }
        let(:chars_highlights) { {chars_pattern => chars_highlight}  }

        subject do
          described_class.new(
            highlights: {
              index: index_highlights,
              numeric: numeric_highlights,
              chars:   chars_highlights
            }
          )
        end

        it "must initialize #style" do
          expect(subject.theme).to be_kind_of(Hexdump::Theme)
        end

        it "must initialize #style.index" do
          expect(subject.theme.index).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.index.highlights" do
          expect(subject.theme.index.highlights[index_pattern].parameters).to eq(index_highlight)
        end

        it "must initialize #style.numeric" do
          expect(subject.theme.numeric).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.numeric.highlights" do
          expect(subject.theme.numeric.highlights[numeric_pattern].parameters).to eq(numeric_highlight)
        end

        it "must initialize #style.chars" do
          expect(subject.theme.chars).to be_kind_of(Hexdump::Theme::Rule)
        end

        it "must populate #style.chars.highlights" do
          expect(subject.theme.chars.highlights[chars_pattern].parameters).to eq(chars_highlight)
        end
      end
    end
  end

  let(:data) do
    'A' * subject.columns + \
    'B' * subject.columns + \
    'C' * subject.columns
  end

  let(:columns) { subject.columns }

  describe "#each_row" do
    let(:rows) do
      [
        [columns * 0, [0x41] * columns, ['A'] * columns],
        [columns * 1, [0x42] * columns, ['B'] * columns],
        [columns * 2, [0x43] * columns, ['C'] * columns],
      ]
    end

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

    context "when #offset is > 0" do
      let(:offset) { 1024 }

      subject { described_class.new(offset: offset) }

      let(:indexes) do
        [
          offset + (columns * 0),
          offset + (columns * 1),
          offset + (columns * 2),
        ]
      end

      it "must start the index counting at #offset" do
        yielded_indexes = []

        subject.each_row(data) do |index,*args|
          yielded_indexes << index
        end

        expect(yielded_indexes).to eq(indexes)
      end
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
        ['*'],
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
          ['*']
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
      [
        ["%.8x" % (columns * 0), ["41"] * columns, "A" * columns],
        ["%.8x" % (columns * 1), ["42"] * columns, "B" * columns],
        ["%.8x" % (columns * 2), ["43"] * columns, "C" * columns],
      ]
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

    [*(0x00..0x1f), *(0x7f..0xff)].each do |byte|
      context "when the row contains an ASCII #{byte.chr.dump} characters" do
        let(:data) { "ABC#{byte.chr}" }

        let(:formatted_rows) do
          [
            ["00000000", ["41", "42", "43", "%.2x" % byte], "ABC."]
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

      let(:formatted_rows) do
        [
          ["%.8x" % (columns * 0), ["41"] * columns, "A" * columns],
          ["%.8x" % (columns * 1), ["42"] * columns, "B" * columns],
          [
            "%.8x" % (columns * 2), ["43"] * (columns / 2), "C" * (columns / 2)
          ]
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

      let(:formatted_rows) do
        [
          [
            "%.8x" % (size * columns * 0),
            ["41414141"] * columns,
            "AAAA" * columns
          ],

          [
            "%.8x" % (size * columns * 1),
            [nil],
            "ABC"
          ]
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

      let(:formatted_rows) do
        [
          ["%.8x" % (columns * 0), ["41"] * columns, "A" * columns],
          ["%.8x" % (columns * 1), ["42"] * columns, "B" * columns],
          ["*"],
          ["%.8x" % (columns * 4), ["43"] * columns, "C" * columns]
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

        let(:formatted_rows) do
          [
            ["%.8x" % (columns * 0), ["41"] * columns, 'A' * columns],
            ["%.8x" % (columns * 1), ["42"] * columns, 'B' * columns],
            ["%.8x" % (columns * 2), ["42"] * columns, 'B' * columns],
            ["%.8x" % (columns * 3), ["42"] * columns, 'B' * columns],
            ["%.8x" % (columns * 4), ["43"] * columns, 'C' * columns]
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
        let(:bytes) { data.bytes }

        let(:formatted_rows) do
          [
            [subject.index % 0, bytes.map { |b| subject.numeric % b }, "A.B"]
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
        let(:bytes) { data.bytes }

        let(:formatted_rows) do
          [
            [subject.index % 0, bytes.map { |b| subject.numeric % b }, "A..B"]
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

    context "when #theme is initialized" do
      let(:ansi_reset) { Hexdump::Theme::ANSI::RESET }
      let(:ansi_green) { Hexdump::Theme::ANSI::PARAMETERS[:green] }
      let(:ansi_blue)  { Hexdump::Theme::ANSI::PARAMETERS[:blue]  }

      let(:ansi_reset) { Hexdump::Theme::ANSI::RESET }

      context "and #style.index.theme is set" do
        subject { described_class.new(style: {index: :cyan}) }

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:cyan] }

        let(:index_format) { "#{ansi_style}%.8x#{ansi_reset}" }
        let(:formatted_rows) do
          [
            [index_format % (columns * 0), ["41"] * columns, "A" * columns],
            [index_format % (columns * 1), ["42"] * columns, "B" * columns],
            [index_format % (columns * 2), ["43"] * columns, "C" * columns],
          ]
        end

        it "must apply ANSI control sequences around the index column" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end

        let(:formatted_index)  do
          "#{ansi_style}%.8x#{ansi_reset}" % data.length
        end

        it "must apply ANSI control sequences around the returned index" do
          index = subject.each_formatted_row(data) do |*row|
          end

          expect(index).to eq(formatted_index)
        end
      end

      context "and #style.index.highlights is populated" do
        subject do
          described_class.new(
            highlights: {
              index: {/00$/ => :bold}
            }
          )
        end

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:bold] }

        let(:highlighted_index) { "000000#{ansi_style}00#{ansi_reset}" }
        let(:formatted_rows) do
          [
            [highlighted_index,      ["41"] * columns, "A" * columns],
            ["%.8x" % (columns * 1), ["42"] * columns, "B" * columns],
            ["%.8x" % (columns * 2), ["43"] * columns, "C" * columns],
          ]
        end

        it "must selectively insert ANSI control sequences to the index column" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "and #style.numeric.theme is set" do
        subject { described_class.new(style: {numeric: :blue}) }

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:blue] }

        let(:formatted_rows) do
          [
            ["%.8x" % (columns * 0), ["#{ansi_style}41#{ansi_reset}"] * columns, "A" * columns],
            ["%.8x" % (columns * 1), ["#{ansi_style}42#{ansi_reset}"] * columns, "B" * columns],
            ["%.8x" % (columns * 2), ["#{ansi_style}43#{ansi_reset}"] * columns, "C" * columns],
          ]
        end

        it "must apply ANSI control sequences around each numeric column" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "and #style.numeric.highlights is populated" do
        subject do
          described_class.new(
            highlights: {
              numeric: {/^4/ => :green}
            }
          )
        end

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:green] }

        let(:formatted_rows) do
          [
            ["%.8x" % (columns * 0), ["#{ansi_style}4#{ansi_reset}1"] * columns, "A" * columns],
            ["%.8x" % (columns * 1), ["#{ansi_style}4#{ansi_reset}2"] * columns, "B" * columns],
            ["%.8x" % (columns * 2), ["#{ansi_style}4#{ansi_reset}3"] * columns, "C" * columns],
          ]
        end

        it "must selectively insert ANSI control sequences to the numeric columns" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "and #style.chars.theme is set" do
        subject { described_class.new(style: {chars: :green}) }

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:green] }

        let(:formatted_rows) do
          [
            ["%.8x" % (columns * 0), ["41"] * columns, "#{ansi_style}#{"A" * columns}#{ansi_reset}"],
            ["%.8x" % (columns * 1), ["42"] * columns, "#{ansi_style}#{"B" * columns}#{ansi_reset}"],
            ["%.8x" % (columns * 2), ["43"] * columns, "#{ansi_style}#{"C" * columns}#{ansi_reset}"],
          ]
        end

        it "must apply ANSI control sequences around the chars column" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "and #style.chars.highlights is populated" do
        subject do
          described_class.new(
            highlights: {
              chars: {/[AC]/ => :red}
            }
          )
        end

        let(:ansi_style)  { Hexdump::Theme::ANSI::PARAMETERS[:red] }

        let(:formatted_rows) do
          [
            ["%.8x" % (columns * 0), ["41"] * columns, "#{ansi_style}A#{ansi_reset}" * columns],
            ["%.8x" % (columns * 1), ["42"] * columns, "B" * columns],
            ["%.8x" % (columns * 2), ["43"] * columns, "#{ansi_style}C#{ansi_reset}" * columns],
          ]
        end

        it "must selectively insert ANSI control sequences to the chars column" do
          yielded_rows = []

          subject.each_formatted_row(data) do |*row|
            yielded_rows << row
          end

          expect(yielded_rows).to eq(formatted_rows)
        end
      end

      context "but the ansi: keyword is false" do
        subject do
          described_class.new(
            style: {
              index:   :cyan,
              numeric: :blue,
              chars:   :green
            },
            highlights: {
              index:   {/00$/ => :bold},
              numeric: {/^4/ => :green},
              chars:   {/[AC]/ => :red}
            }
          )
        end

        it "must not apply any ANSI control sequences" do
          yielded_rows = []

          subject.each_formatted_row(data, ansi: false) do |*row|
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

  describe "#each_line" do
    let(:lines) do
      [
        "00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|#{$/}",
        "00000010  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
        "00000020  43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43  |CCCCCCCCCCCCCCCC|#{$/}",
        "00000030#{$/}"
      ]
    end

    it "must yield each line" do
      yielded_lines = []

      subject.each_line(data) do |line|
        yielded_lines << line
      end

      expect(yielded_lines).to eq(lines)
    end

    context "when the data's length is not evenly divisble by the columns" do
      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'C' * (columns / 2)
      end

      let(:lines) do
        [
          "00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|#{$/}",
          "00000010  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "00000020  43 43 43 43 43 43 43 43                          |CCCCCCCC|#{$/}",
          "00000028#{$/}"
        ]
      end

      it "must yield the last left-adjusted partial row" do
        yielded_lines = []

        subject.each_line(data) do |line|
          yielded_lines << line
        end

        expect(yielded_lines).to eq(lines)
      end
    end

    context "when the data contains repeating rows" do
      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'B' * columns + \
        'B' * columns + \
        'C' * columns
      end

      let(:lines) do
        [
          "00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|#{$/}",
          "00000010  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "*#{$/}",
          "00000040  43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43  |CCCCCCCCCCCCCCCC|#{$/}",
          "00000050#{$/}"
        ]
      end

      it "must yield the formatted lines and a '*' row to denote the beginning of repeating lines" do
        yielded_lines = []

        subject.each_line(data) do |line|
          yielded_lines << line
        end

        expect(yielded_lines).to eq(lines)
      end
    end

    context "when initialized with repeating: true" do
      subject { described_class.new(repeating: true) }

      let(:data) do
        'A' * columns + \
        'B' * columns + \
        'B' * columns + \
        'B' * columns + \
        'C' * columns
      end

      let(:lines) do
        [
          "00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAAAAAAAA|#{$/}",
          "00000010  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "00000020  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "00000030  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "00000040  43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43  |CCCCCCCCCCCCCCCC|#{$/}",
          "00000050#{$/}"
        ]
      end

      it "must yield repeating lines" do
        yielded_lines = []

        subject.each_line(data) do |line|
          yielded_lines << line
        end

        expect(yielded_lines).to eq(lines)
      end
    end

    context "when initialized with chars: false" do
      subject { described_class.new(chars: false) }

      let(:lines) do
        [
          "00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41#{$/}",
          "00000010  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42#{$/}",
          "00000020  43 43 43 43 43 43 43 43 43 43 43 43 43 43 43 43#{$/}",
          "00000030#{$/}"
        ]
      end

      it "must omit the characters column" do
        yielded_lines = []

        subject.each_line(data) do |line|
          yielded_lines << line
        end

        expect(yielded_lines).to eq(lines)
      end
    end

    context "when initialized wth group_columns: ..." do
      subject { described_class.new(group_columns: 4) }

      let(:lines) do
        [
          "00000000  41 41 41 41  41 41 41 41  41 41 41 41  41 41 41 41  |AAAAAAAAAAAAAAAA|#{$/}",
          "00000010  42 42 42 42  42 42 42 42  42 42 42 42  42 42 42 42  |BBBBBBBBBBBBBBBB|#{$/}",
          "00000020  43 43 43 43  43 43 43 43  43 43 43 43  43 43 43 43  |CCCCCCCCCCCCCCCC|#{$/}",
          "00000030#{$/}"
        ]
      end

      it "must group columns together with an extra space" do
        yielded_lines = []

        subject.each_line(data) do |line|
          yielded_lines << line
        end

        expect(yielded_lines).to eq(lines)
      end
    end
  end

  let(:lines) { subject.each_line(data).to_a }

  describe "#hexdump" do
    it "must print each line of the hexdump to stdout" do
      expect {
        subject.hexdump(data)
      }.to output(lines.join).to_stdout
    end

    context "when the output: keyword argument is given" do
      let(:output) { StringIO.new }

      it "must print each line of hte hexdump to the given output" do
        subject.hexdump(data, output: output)

        expect(output.string).to eq(lines.join)
      end

      context "but the output does not support #<<" do
        let(:output) { Object.new }

        it do
          expect {
            subject.hexdump(data, output: output)
          }.to raise_error(ArgumentError,"output must support the #<< method")
        end
      end
    end
  end

  describe "#dump" do
    it "must append each line of the hexdump to the given String" do
      expect(subject.dump(data)).to eq(lines.join)
    end
  end
end
