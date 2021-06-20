require 'spec_helper'
require 'hexdump/numeric/octal'
require 'hexdump/type'

describe Hexdump::Numeric::Octal do
  describe "#initialize" do
    subject { described_class.new(type) }

    context "when given a Type::Int type" do
      context "and size is 1" do
        let(:type) { Hexdump::Type::Int8.new }

        it "must set #width to 3 + 1" do
          expect(subject.width).to eq(3 + 1)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::Int16.new }

        it "must set #width to 6 + 1" do
          expect(subject.width).to eq(6 + 1)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::Int32.new }

        it "must set #width to 11 + 1" do
          expect(subject.width).to eq(11 + 1)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::Int64.new }

        it "must set #width to 22 + 1" do
          expect(subject.width).to eq(22 + 1)
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

        it "must set #width to 3" do
          expect(subject.width).to eq(3)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::UInt16.new }

        it "must set #width to 6" do
          expect(subject.width).to eq(6)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        it "must set #width to 11" do
          expect(subject.width).to eq(11)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        it "must set #width to 22" do
          expect(subject.width).to eq(22)
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
        expect {
          described_class.new(type)
        }.to raise_error(Hexdump::Numeric::IncompatibleTypeError,"cannot format floating-point numbers in octal")
      end
    end

    context "when given a non-Type object" do
      let(:type) { Object.new }

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
      let(:octal) { '017' }

      it "must return a octal string of length 8" do
        expect(subject % value).to eq(octal)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int8.new }

        context "and the value is positive" do
          it "must return a octal string of length 8 prefixed with a ' '" do
            expect(subject % value).to eq(" #{octal}")
          end
        end

        context "and the value is negative" do
          it "must return a octal string of length 8 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{octal}")
          end
        end
      end
    end

    context "when the given type has size 2" do
      let(:type) { Hexdump::Type::UInt16.new }

      let(:value) { 0xff }
      let(:octal) { '000377' }

      it "must return a octal string of length 16" do
        expect(subject % value).to eq(octal)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int16.new }

        context "and the value is positive" do
          it "must return a octal string of length 16 prefixed with a ' '" do
            expect(subject % value).to eq(" #{octal}")
          end
        end

        context "and the value is negative" do
          it "must return a octal string of length 16 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{octal}")
          end
        end
      end
    end

    context "when the given type has size 4" do
      let(:type) { Hexdump::Type::UInt32.new }

      let(:value) { 0xffff }
      let(:octal) { '00000177777' }

      it "must return a octal string of length 32" do
        expect(subject % value).to eq(octal)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int32.new }

        context "and the value is positive" do
          it "must return a octal string of length 32 prefixed with a ' '" do
            expect(subject % value).to eq(" #{octal}")
          end
        end

        context "and the value is negative" do
          it "must return a octal string of length 32 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{octal}")
          end
        end
      end
    end

    context "when the given type has size 8" do
      let(:type) { Hexdump::Type::UInt64.new }

      let(:value)  { 0xffffffff }
      let(:octal) { '0000000000037777777777' }

      it "must return a octal string of length 64" do
        expect(subject % value).to eq(octal)
      end

      context "and is signed" do
        let(:type) { Hexdump::Type::Int64.new }

        context "and the value is positive" do
          it "must return a octal string of length 64 prefixed with a ' '" do
            expect(subject % value).to eq(" #{octal}")
          end
        end

        context "and the value is negative" do
          it "must return a octal string of length 64 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{octal}")
          end
        end
      end
    end
  end
end
