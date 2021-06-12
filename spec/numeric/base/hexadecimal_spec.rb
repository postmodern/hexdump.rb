require 'spec_helper'
require 'hexdump/numeric/base/hexadecimal'
require 'hexdump/type'

describe Hexdump::Numeric::Base::Hexadecimal do
  describe "#initialize" do
    subject { described_class.new(type) }

    context "when given a Type::Int type" do
      context "and size is 1" do
        let(:type) { Hexdump::Type::Int8.new }

        it "must set #width to 2 + 1" do
          expect(subject.width).to eq(2 + 1)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::Int16.new }

        it "must set #width to 4 + 1" do
          expect(subject.width).to eq(4 + 1)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::Int32.new }

        it "must set #width to 8 + 1" do
          expect(subject.width).to eq(8 + 1)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::Int64.new }

        it "must set #width to 16 + 1" do
          expect(subject.width).to eq(16 + 1)
        end
      end

      context "and it has an unsupported size" do
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

        it "must set #width to 2" do
          expect(subject.width).to eq(2)
        end
      end

      context "and size is 2" do
        let(:type) { Hexdump::Type::UInt16.new }

        it "must set #width to 4" do
          expect(subject.width).to eq(4)
        end
      end

      context "and size is 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        it "must set #width to 8" do
          expect(subject.width).to eq(8)
        end
      end

      context "and size is 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        it "must set #width to 16" do
          expect(subject.width).to eq(16)
        end
      end

      context "and it has an unsupported size" do
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
      context "and the type size is 4" do
        let(:type) { Hexdump::Type::Float32.new }

        it "must set #width to 20 + 1" do
          begin
            expect(subject.width).to eq(20 + 1)
          rescue NotImplementedError => error
            skip error.message
          end
        end
      end

      context "and the type size is 8" do
        let(:type) { Hexdump::Type::Float64.new }

        it "must set #width to 20 + 1" do
          begin
            expect(subject.width).to eq(20 + 1)
          rescue NotImplementedError => error
            skip error.message
          end
        end
      end
    end
  end

  describe "#%" do
    subject { described_class.new(type) }

    context "when the given type is a Type::UInt" do
      context "and the type's size is 1" do
        let(:type) { Hexdump::Type::UInt8.new }

        let(:value) { 0xf }
        let(:hex)   { '0f' }

        it "must return a hexadecimal string of length 2" do
          expect(subject % value).to eq(hex)
        end
      end

      context "when the given type has size 2" do
        let(:type) { Hexdump::Type::UInt16.new }

        let(:value) { 0xff }
        let(:hex)   { '00ff' }

        it "must return a left-padded decimal string of length 4" do
          expect(subject % value).to eq(hex)
        end
      end

      context "when the given type has size 4" do
        let(:type) { Hexdump::Type::UInt32.new }

        let(:value) { 0xffff }
        let(:hex)   { '0000ffff' }

        it "must return a left-padded decimal string of length 8" do
          expect(subject % value).to eq(hex)
        end
      end

      context "when the given type has size 8" do
        let(:type) { Hexdump::Type::UInt64.new }

        let(:value) { 0xffffffff }
        let(:hex)   { '00000000ffffffff' }

        it "must return a hexadecimal string of length 16" do
          expect(subject % value).to eq(hex)
        end
      end
    end

    context "when the given type is a Type::Int" do
      context "and the type's size is 1" do
        let(:type) { Hexdump::Type::Int8.new }

        let(:value) { 0xf }
        let(:hex)   { '0f' }

        context "and the value is positive" do
          it "must return a hexadecimal string prefixed with a ' '" do
            expect(subject % value).to eq(" #{hex}")
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string prefixed with a '-'" do
            expect(subject % -value).to eq("-#{hex}")
          end
        end
      end

      context "and the given type has size 2" do
        let(:type) { Hexdump::Type::Int16.new }

        let(:value) { 0xff }
        let(:hex)   { '00ff' }

        context "and the value is positive" do
          it "must return a hexadecimal string prefixed with a ' '" do
            expect(subject % value).to eq(" #{hex}")
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string prefixed with a '-'" do
            expect(subject % -value).to eq("-#{hex}")
          end
        end
      end

      context "and the given type has size 4" do
        let(:type) { Hexdump::Type::Int32.new }

        let(:value) { 0xffff }
        let(:hex)   { '0000ffff' }

        context "and the value is positive" do
          it "must return a hexadecimal string of prefixed with a ' '" do
            expect(subject % value).to eq(" #{hex}")
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string prefixed with a '-'" do
            expect(subject % -value).to eq("-#{hex}")
          end
        end
      end

      context "and the given type has size 8" do
        let(:type) { Hexdump::Type::Int64.new }

        let(:value) { 0xffffffff }
        let(:hex)   { '00000000ffffffff' }

        context "and the value is positive" do
          it "must return a hexadecimal string of length 64 prefixed with a ' '" do
            expect(subject % value).to eq(" #{hex}")
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string of length 64 prefixed with a '-'" do
            expect(subject % -value).to eq("-#{hex}")
          end
        end
      end
    end

    context "when the given type is a Type::Float" do
      let(:value) { 1.234567899 }
      let(:hex)   { '0x1.3c0ca44ee57c8p+0' }

      context "when the given type has size 4" do
        let(:type) { Hexdump::Type::Float32.new }

        context "and the value is positive" do
          it "must return a hexadecimal string of length 20 prefixed with a ' '" do
            begin
              expect(subject % value).to eq(" #{hex}")
            rescue NotImplementedError => error
              skip error.message
            end
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string of length 20 prefixed with a '-'" do
            begin
              expect(subject % -value).to eq("-#{hex}")
            rescue NotImplementedError => error
              skip error.message
            end
          end
        end
      end

      context "when the given type has size 8" do
        let(:type) { Hexdump::Type::Float64.new }

        context "and the value is positive" do
          it "must return a hexadecimal string of length 20 prefixed with a ' '" do
            begin
              expect(subject % value).to eq(" #{hex}")
            rescue NotImplementedError => error
              skip error.message
            end
          end
        end

        context "and the value is negative" do
          it "must return a hexadecimal string of length 20 prefixed with a '-'" do
            begin
              expect(subject % -value).to eq("-#{hex}")
            rescue NotImplementedError => error
              skip error.message
            end
          end
        end
      end
    end
  end
end
