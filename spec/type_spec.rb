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

  describe "#unsigned?" do
    let(:size) { 4 }

    subject { described_class.new(size: size, signed: signed) }

    context "when initialized with signed: true" do
      let(:signed) { true }

      it do
        expect(subject.unsigned?).to be(false)
      end
    end

    context "when initialized with signed: false" do
      let(:signed) { false }

      it do
        expect(subject.unsigned?).to be(true)
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

  describe Hexdump::Type::UInt8 do
    it { expect(subject).kind_of?(Hexdump::Type::UInt) }

    describe "#initialize" do
      it "must default #signed? to false" do
        expect(subject.signed?).to be(false)
      end

      it "must default #size to 1" do
        expect(subject.size).to be(1)
      end

      it "must default #endian to nil" do
        expect(subject.endian).to be(nil)
      end
    end
  end

  describe Hexdump::Type::UInt16 do
    it { expect(subject).kind_of?(Hexdump::Type::UInt) }

    describe "#initialize" do
      it "must default #signed? to false" do
        expect(subject.signed?).to be(false)
      end

      it "must default #size to 2" do
        expect(subject.size).to be(2)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::UInt32 do
    it { expect(subject).kind_of?(Hexdump::Type::UInt) }

    describe "#initialize" do
      it "must default #signed? to false" do
        expect(subject.signed?).to be(false)
      end

      it "must default #size to 4" do
        expect(subject.size).to be(4)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::UInt64 do
    it { expect(subject).kind_of?(Hexdump::Type::UInt) }

    describe "#initialize" do
      it "must default #signed? to false" do
        expect(subject.signed?).to be(false)
      end

      it "must default #size to 8" do
        expect(subject.size).to be(8)
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

  describe Hexdump::Type::Int8 do
    it { expect(subject).kind_of?(Hexdump::Type::Int) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #size to 1" do
        expect(subject.size).to be(1)
      end

      it "must default #endian to nil" do
        expect(subject.endian).to be(nil)
      end
    end
  end

  describe Hexdump::Type::Int16 do
    it { expect(subject).kind_of?(Hexdump::Type::Int) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #size to 2" do
        expect(subject.size).to be(2)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::Int32 do
    it { expect(subject).kind_of?(Hexdump::Type::Int) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #size to 4" do
        expect(subject.size).to be(4)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::Int64 do
    it { expect(subject).kind_of?(Hexdump::Type::Int) }

    describe "#initialize" do
      it "must default #signed? to true" do
        expect(subject.signed?).to be(true)
      end

      it "must default #size to 8" do
        expect(subject.size).to be(8)
      end

      it "must default #endian to NATIVE_ENDIAN" do
        expect(subject.endian).to eq(Hexdump::Type::NATIVE_ENDIAN)
      end
    end
  end

  describe Hexdump::Type::Char do
    describe "#initialize" do
      it "must set #signed? to true" do
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

  describe Hexdump::Type::UChar do
    describe "#initialize" do
      it "must set #signed? to false" do
        expect(subject.signed?).to be(false)
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

  describe Hexdump::Type::Float32 do
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    describe "#initialize" do
      it "must default #size to 4" do
        expect(subject.size).to be(4)
      end
    end
  end

  describe Hexdump::Type::Float64 do
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    describe "#initialize" do
      it "must default #size to 8" do
        expect(subject.size).to be(8)
      end
    end
  end
end
