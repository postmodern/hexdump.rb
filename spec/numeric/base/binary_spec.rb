require 'spec_helper'
require 'hexdump/numeric/base/binary'
require 'hexdump/type'

describe Hexdump::Numeric::Base::Binary do
  describe "#initialize" do
    subject { described_class.new(type) }

    context "when given a Type::Int type" do
      context "and size is 1" do
        let(:type) { Hexdump::Type::Int8.new }

        it "must set #width to 8 + 1" do
          expect(subject.width).to eq(8 + 1)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::Int16.new }

        it "must set #width to 16 + 1" do
          expect(subject.width).to eq(16 + 1)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::Int32.new }

        it "must set #width to 32 + 1" do
          expect(subject.width).to eq(32 + 1)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::Int64.new }

        it "must set #width to 64 + 1" do
          expect(subject.width).to eq(64 + 1)
        end
      end

      context "but the type has an unsupported size" do
        class UnsupportedIntType < Hexdump::Type::Int

          def initialize
            super(size: 3)
          end

        end

        let(:type) { UnsupportedIntType.new }

        it do
          expect { described_class.new(type) }.to raise_error(NotImplementedError)
        end
      end
    end

    context "when given a Type::UInt type" do
      context "and size is 1" do
        let(:type) { Hexdump::Type::UInt8.new }

        it "must set #width to 8" do
          expect(subject.width).to eq(8)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::UInt16.new }

        it "must set #width to 16" do
          expect(subject.width).to eq(16)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        it "must set #width to 32" do
          expect(subject.width).to eq(32)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        it "must set #width to 64" do
          expect(subject.width).to eq(64)
        end
      end

      context "but the type has an unsupported size" do
        class UnsupportedUIntType < Hexdump::Type::UInt

          def initialize
            super(size: 3)
          end

        end

        let(:type) { UnsupportedUIntType.new }

        it do
          expect { described_class.new(type) }.to raise_error(NotImplementedError)
        end
      end
    end

    context "when given a Type::Float type" do
      let(:type) { Hexdump::Type::Float32.new }

      it do
        expect { described_class.new(type) }.to raise_error(TypeError)
      end
    end
  end

  describe "#%" do
    subject { described_class.new(type) }

    context "when the given type has size 1" do
      let(:type) { Hexdump::Type::UInt8.new }

      let(:value) { 0xf }
      let(:binary) { '00001111' }

      it "must return a binary string of length 8" do
        expect(subject % value).to eq(binary)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int8.new }

        context "and the value is positive" do
          it "must return a binary string of length 8 prefixed with a ' '" do
            expect(subject % value).to eq(" #{binary}")
          end
        end

        context "and the value is negative" do
          it "must return a binary string of length 8 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{binary}")
          end
        end
      end
    end

    context "when the given type has size 2" do
      let(:type) { Hexdump::Type::UInt16.new }

      let(:value) { 0xff }
      let(:binary) { '0000000011111111' }

      it "must return a binary string of length 16" do
        expect(subject % value).to eq(binary)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int16.new }

        context "and the value is positive" do
          it "must return a binary string of length 16 prefixed with a ' '" do
            expect(subject % value).to eq(" #{binary}")
          end
        end

        context "and the value is negative" do
          it "must return a binary string of length 16 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{binary}")
          end
        end
      end
    end

    context "when the given type has size 4" do
      let(:type) { Hexdump::Type::UInt32.new }

      let(:value) { 0xffff }
      let(:binary) { '00000000000000001111111111111111' }

      it "must return a binary string of length 32" do
        expect(subject % value).to eq(binary)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int32.new }

        context "and the value is positive" do
          it "must return a binary string of length 32 prefixed with a ' '" do
            expect(subject % value).to eq(" #{binary}")
          end
        end

        context "and the value is negative" do
          it "must return a binary string of length 32 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{binary}")
          end
        end
      end
    end

    context "when the given type has size 8" do
      let(:type) { Hexdump::Type::UInt64.new }

      let(:value)  { 0xffffffff }
      let(:binary) { '0000000000000000000000000000000011111111111111111111111111111111' }

      it "must return a binary string of length 64" do
        expect(subject % value).to eq(binary)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int64.new }

        context "and the value is positive" do
          it "must return a binary string of length 64 prefixed with a ' '" do
            expect(subject % value).to eq(" #{binary}")
          end
        end

        context "and the value is negative" do
          it "must return a binary string of length 64 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{binary}")
          end
        end
      end
    end
  end
end
