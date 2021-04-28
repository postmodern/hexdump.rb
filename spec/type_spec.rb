require 'spec_helper'
require 'hexdump/type'

describe Hexdump::Type do
  describe "#initialize" do
    let(:size) { 4 }
    let(:signed) { true }

    subject { described_class.new(size: size, signed: signed) }

    it "must set #size" do
      expect(subject.size).to eq(size)
    end

    it "must not set #endian" do
      expect(subject.endian).to be(nil)
    end

    it "must set #signed?" do
      expect(subject.signed?).to eq(signed)
    end

    context "when given endian:" do
      let(:endian) { :big }

      subject do
        described_class.new(size: size, endian: endian, signed: signed)
      end

      it "must set #endian" do
        expect(subject.endian).to eq(endian)
      end
    end
  end

  describe "#signed?" do
    let(:size) { 4 }

    subject { described_class.new(size: size, signed: signed) }

    context "when initialized with signed: true" do
      let(:signed) { true }

      it do
        expect(subject.signed?).to be(true)
      end
    end

    context "when initialized with signed: false" do
      let(:signed) { false }

      it do
        expect(subject.signed?).to be(false)
      end
    end
  end

  describe Hexdump::Type::UInt do
    subject { described_class.new(size: 4) }

    describe "#initialize" do
      it "must default #signed? to false" do
        expect(subject.signed?).to be(false)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::Int do
    subject { described_class.new(size: 4) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::Char do
    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must set #size to 1" do
        expect(subject.size).to eq(1)
      end

      it "must set #endian to nil" do
        expect(subject.endian).to be(nil)
      end
    end
  end

  describe Hexdump::Type::Float do
    subject { described_class.new(size: 4) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end
end
