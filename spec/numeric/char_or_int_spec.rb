require 'spec_helper'
require 'hexdump/numeric/char_or_int'
require 'hexdump/numeric/hexadecimal'
require 'hexdump/type'

describe Hexdump::Numeric::CharOrInt do
  let(:type) { Hexdump::Type::UInt8.new }
  let(:base) { Hexdump::Numeric::Hexadecimal.new(type) }

  subject { described_class.new(base) }

  describe "#initialize" do
    it "must set #base" do
      expect(subject.base).to eq(base)
    end

    it "must default #encoding to nil" do
      expect(subject.encoding).to be(nil)
    end

    it "must initialize the format string" do
      expect(subject.to_s).to eq("%#{base.width}s")
    end

    context "when given an encoding" do
      let(:encoding) { Encoding::UTF_8 }

      subject { described_class.new(base,encoding) }

      it "must set #encoding" do
        expect(subject.encoding).to eq(encoding)
      end
    end
  end

  describe "#width" do
    it "return the base's #width" do
      expect(subject.width).to eq(base.width)
    end
  end

  describe "#%" do
    (0x20..0x7e).each do |byte|
      context "when given #{byte.to_s(16)}" do
        it "must return ' #{byte.chr}'" do
          expect(subject % byte).to eq(" #{byte.chr}")
        end
      end
    end

    context "when given 0x00" do
      it "must return '\\0'" do
        expect(subject % 0x00).to eq("\\0")
      end
    end

    context "when given 0x07" do
      it "must return '\\a'" do
        expect(subject % 0x07).to eq("\\a")
      end
    end

    context "when given 0x08" do
      it "must return '\\b'" do
        expect(subject % 0x08).to eq("\\b")
      end
    end

    context "when given 0x09" do
      it "must return '\\t'" do
        expect(subject % 0x09).to eq("\\t")
      end
    end

    context "when given 0x0a" do
      it "must return '\\n'" do
        expect(subject % 0x0a).to eq("\\n")
      end
    end

    context "when given 0x0b" do
      it "must return '\\v'" do
        expect(subject % 0x0b).to eq("\\v")
      end
    end

    context "when given 0x0c" do
      it "must return '\\f'" do
        expect(subject % 0x0c).to eq("\\f")
      end
    end

    context "when given 0x0d" do
      it "must return '\\r'" do
        expect(subject % 0x0d).to eq("\\r")
      end
    end

    context "when given a byte that does not map to a printable character" do
      it "must return the formatted byte" do
        expect(subject % 0xff).to eq("ff")
      end
    end

    context "when the numeric base has a width > 2" do
      let(:type) { Hexdump::Type::UInt16.new }
      let(:width) { base.width }

      it "must left-pad printable characters with width-1 additional spaces" do
        left_pad = ' ' * (width - 1)

        expect(subject % 0x41).to eq("#{left_pad}A")
      end

      it "must left-pad escaped characters with width-2 additional spaces" do
        left_pad = ' ' * (width - 2)

        expect(subject % 0x00).to eq("#{left_pad}\\0")
      end

      it "must not left-pad numerically formatted values with spaces" do
        expect(subject % 0xff).to eq("00ff")
      end
    end

    context "when initialized with an encoding" do
      let(:encoding) { Encoding::UTF_8 }

      subject { described_class.new(base,encoding) }

      context "when given 0x00" do
        it "must return '\\0'" do
          expect(subject % 0x00).to eq("\\0")
        end
      end

      context "when given 0x07" do
        it "must return '\\a'" do
          expect(subject % 0x07).to eq("\\a")
        end
      end

      context "when given 0x08" do
        it "must return '\\b'" do
          expect(subject % 0x08).to eq("\\b")
        end
      end

      context "when given 0x09" do
        it "must return '\\t'" do
          expect(subject % 0x09).to eq("\\t")
        end
      end

      context "when given 0x0a" do
        it "must return '\\n'" do
          expect(subject % 0x0a).to eq("\\n")
        end
      end

      context "when given 0x0b" do
        it "must return '\\v'" do
          expect(subject % 0x0b).to eq("\\v")
        end
      end

      context "when given 0x0c" do
        it "must return '\\f'" do
          expect(subject % 0x0c).to eq("\\f")
        end
      end

      context "when given 0x0d" do
        it "must return '\\r'" do
          expect(subject % 0x0d).to eq("\\r")
        end
      end

      context "when given a byte that does map to a printable character" do
        it "must return the formatted character" do
          expect(subject % 0x2603).to eq(" ☃")
        end
      end

      context "when given a byte that does not map to a printable character" do
        let(:byte) { 888 }

        it "must return the numeric formatted value" do
          expect(subject % byte).to eq(base % byte)
        end
      end

      context "when given a byte that does not map any character" do
        let(:byte) { 0xd800 }

        it "must return the numeric formatted value" do
          expect(subject % byte).to eq(base % byte)
        end
      end

      context "when given a negative value" do
        let(:byte) { -1 }

        it "must return the numeric formatted value" do
          expect(subject % byte).to eq(base % byte)
        end
      end
    end
  end
end
