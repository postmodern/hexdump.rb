require 'spec_helper'
require 'hexdump/numeric/decimal'
require 'hexdump/type'

describe Hexdump::Numeric::Decimal do
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

        it "must set #width to 5 + 1" do
          expect(subject.width).to eq(5 + 1)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::Int32.new }

        it "must set #width to 10 + 1" do
          expect(subject.width).to eq(10 + 1)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::Int64.new }

        it "must set #width to 20 + 1" do
          expect(subject.width).to eq(20 + 1)
        end
      end

      context "but it has an unsupported size" do
         class UnsupportedIntType < Hexdump::Type::Int

          def initialize
            super(size: 3)
          end

        end

        let(:type) { UnsupportedIntType.new }

        it do
          expect {
            described_class.new(type)
          }.to raise_error(NotImplementedError)
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

        it "must set #width to 5" do
          expect(subject.width).to eq(5)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        it "must set #width to 10" do
          expect(subject.width).to eq(10)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        it "must set #width to 20" do
          expect(subject.width).to eq(20)
        end
      end

      context "but it has an unsupported size" do
         class UnsupportedUIntType < Hexdump::Type::UInt

          def initialize
            super(size: 3)
          end

        end

        let(:type) { UnsupportedUIntType.new }

        it do
          expect {
            described_class.new(type)
          }.to raise_error(NotImplementedError)
        end
      end
    end

    context "when given a Type::Float type" do
      context "and size is 4" do
        let(:type) { Hexdump::Type::Float32.new }

        it "must set #width to 12 + 1" do
          expect(subject.width).to eq(12 + 1)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::Float64.new }

        it "must set #width to 20 + 1" do
          expect(subject.width).to eq(20 + 1)
        end
      end

      context "but it has an unsupported size" do
        class UnsupportedFloatType < Hexdump::Type::Float

          def initialize
            super(size: 3)
          end

        end

        let(:type) { UnsupportedFloatType.new }

        it do
          expect {
            described_class.new(type)
          }.to raise_error(NotImplementedError)
        end
      end
    end
  end

  describe "#%" do
    subject { described_class.new(type) }

    context "when the given type is a Type::UInt" do
      context "and the given type has size 1" do
        let(:type) { Hexdump::Type::UInt8.new }

        let(:value) { 0xf }
        let(:decimal) { '15' }

        it "must return a left-padded decimal string of length 3" do
          expect(subject % value).to eq(" #{decimal}")
        end
      end

      context "and the given type has size 2" do
        let(:type) { Hexdump::Type::UInt16.new }

        let(:value) { 0xff }
        let(:decimal) { '255' }

        it "must return a left-padded decimal string of length 5" do
          expect(subject % value).to eq("  #{decimal}")
        end
      end

      context "and the given type has size 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        let(:value) { 0xffff }
        let(:decimal) { '65535' }

        it "must return a left-padded decimal string of length 10" do
          expect(subject % value).to eq("     #{decimal}")
        end
      end

      context "and the given type has size 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        let(:value)  { 0xffffffff }
        let(:decimal) { '4294967295' }

        it "must return a left-padded decimal string of length 20" do
          expect(subject % value).to eq("          #{decimal}")
        end
      end
    end

    context "when the given type is a Type::Int" do
      context "and the given type has size 1" do
        let(:type) { Hexdump::Type::Int8.new }

        let(:value) { 0xf }
        let(:decimal) { '15' }

        context "and the value is positive" do
          it "must return a left-padded decimal string prefixed with a ' '" do
            expect(subject % value).to eq(" #{decimal}")
          end
        end

        context "and the value is negative" do
          it "must return a left-padded decimal string prefixed with a '-'" do
            expect(subject % -value).to eq("-#{decimal}")
          end
        end
      end

      context "and the given type has size 2" do
        let(:type) { Hexdump::Type::Int16.new }

        let(:value) { 0xff }
        let(:decimal) { '255' }

        context "and the value is positive" do
          it "must return a left-padded decimal string prefixed with a ' '" do
            expect(subject % value).to eq("  #{decimal}")
          end
        end

        context "and the value is negative" do
          it "must return a left-padded decimal string prefixed with a '-'" do
            expect(subject % -value).to eq(" -#{decimal}")
          end
        end
      end

      context "and the given type has size 4" do
        let(:type) { Hexdump::Type::Int32.new }

        let(:value) { 0xffff }
        let(:decimal) { '65535' }

        context "and the value is positive" do
          it "must return a left-padded decimal string of prefixed with a ' '" do
            expect(subject % value).to eq("     #{decimal}")
          end
        end

        context "and the value is negative" do
          it "must return a left-padded decimal string prefixed with a '-'" do
            expect(subject % -value).to eq("    -#{decimal}")
          end
        end
      end

      context "when the given type has size 8" do
        let(:type) { Hexdump::Type::Int64.new }

        let(:value)  { 0xffffffff }
        let(:decimal) { '4294967295' }

        context "and the value is positive" do
          it "must return a decimal string of length 64 prefixed with a ' '" do
            expect(subject % value).to eq("          #{decimal}")
          end
        end

        context "and the value is negative" do
          it "must return a decimal string of length 64 prefixed with a '-'" do
            expect(subject % -value).to eq("         -#{decimal}")
          end
        end
      end
    end

    context "when the given type is a Type::Float" do
      context "and the given type has size 4" do
        let(:type) { Hexdump::Type::Float32.new }

        let(:value) { 1.123456789}
        let(:float) { "1.123457e+00" }

        context "and the value is positive" do
          it "must return a float string of length 12 prefixed with a ' '" do
            expect(subject % value).to eq(" #{float}")
          end
        end

        context "and the value is negative" do
          it "must return a float string of length 12 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{float}")
          end
        end
      end

      context "and the given type has size 8" do
        let(:type) { Hexdump::Type::Float64.new }

        let(:value) { 1.123456789 }
        let(:float) { "1.123457e+00" }

        context "and the value is positive" do
          it "must return a float string of length 20 prefixed with a ' '" do
            expect(subject % value).to eq("        #{float}")
          end
        end

        context "and the value is negative" do
          it "must return a float string of length 20 prefixed with a '-'" do
            expect(subject % -value).to eq("       -#{float}")
          end
        end
      end
    end
  end
end
