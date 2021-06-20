require 'spec_helper'
require 'hexdump/numeric/chars'
require 'hexdump/numeric/hexadecimal'
require 'hexdump/type'

describe Hexdump::Numeric::Chars do
  let(:type) { Hexdump::Type::UInt8.new }
  let(:base) { Hexdump::Numeric::Hexadecimal.new(type) }

  subject { described_class.new(base) }

  describe "#%" do
    Hexdump::CharMap::ASCII::PRINTABLE.each do |byte,char|
      context "when given #{byte.to_s(16)}" do
        it "must return ' #{char}'" do
          expect(subject % byte).to eq(" #{char}")
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
  end
end
