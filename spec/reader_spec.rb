require 'spec_helper'
require 'hexdump/reader'
require 'hexdump/types'

describe Hexdump::Reader do
  describe "#each_byte" do
    let(:type)  { Hexdump::TYPES[:byte] }
    let(:bytes) { %w[A B C D E F] }
    let(:data)  { bytes.join }

    subject { described_class.new(type) }

    context "when the given data does not define #each_byte" do
      it do
        expect {
          subject.each_byte(Object.new).to_a
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#each_uint" do
    context "when the type has size of 2" do
      let(:uints) { [0xfa01, 0xfb02, 0xfc03, 0xfd04] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint16_le] }
        let(:data)  { uints.pack('S<' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint16_be] }
        let(:data)  { uints.pack('S>' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end
    end

    context "when the type has size of 4" do
      let(:uints) { [0xffeedd01, 0xffccbb02, 0xffaa9903, 0xff887704] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint32_le] }
        let(:data)  { uints.pack('L<' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint32_be] }
        let(:data)  { uints.pack('L>' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end
    end

    context "when the type has size of 8" do
      let(:uints) { [0xffffffff11223344, 0xffffffff55667788, 0xffffffff99aabbcc, 0xffffffffddeeff00] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint64_le] }
        let(:data)  { uints.pack('Q<' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint64_be] }
        let(:data)  { uints.pack('Q>' * uints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*uints)
        end
      end
    end

    context "when the given data does not define #each_byte" do
      it do
        expect {
          subject.each_uint(Object.new).to_a
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#each_slice" do
    let(:type) { Hexdump::TYPES[:int16] }
    let(:data) { 'AABBCCDDEEFF' }

    subject { described_class.new(type) }

    it "must yield each slice of the String" do
      expect { |b|
        subject.each_slice(data,&b)
      }.to yield_successive_args('AA', 'BB', 'CC', 'DD', 'EE', 'FF')
    end

    context "when the given data is not evenly divisible by the type's size" do
      let(:type) { Hexdump::TYPES[:int32] }
      let(:data) { 'AABBCCDDE' }

      it "must pad the last slice with zeros" do
        expect { |b|
          subject.each_slice(data,&b)
        }.to yield_successive_args('AABB', 'CCDD', "E\0\0\0")
      end
    end
  end

  describe "#each_int" do
    context "when the type has size of 2" do
      let(:ints) { [0x0001, -0x0002, 0x0003, -0x0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int16_le] }
        let(:data)  { ints.pack('s<' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int16_be] }
        let(:data)  { ints.pack('s>' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end
    end

    context "when the type has size of 4" do
      let(:ints) { [0x00aa0001, -0x00bb0002, 0x00cc0003, -0x00dd0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int32_le] }
        let(:data)  { ints.pack('l<' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int32_be] }
        let(:data)  { ints.pack('l>' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end
    end

    context "when the type has size of 8" do
      let(:ints) { [0x1122334400aa0001, -0x1122334400bb0002, 0x1122334400cc0003, -0x1122334400dd0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int64_le] }
        let(:data)  { ints.pack('q<' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int64_be] }
        let(:data)  { ints.pack('q>' * ints.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*ints)
        end
      end
    end

    context "when the given data does not define #each_byte" do
      it do
        expect {
          subject.each_int(Object.new).to_a
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#each_float" do
    context "when the type has size of 4" do
      let(:floats) { [1.0, -3.0, 5.0, -7.0, 9.0] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:float_le] }
        let(:data)  { floats.pack('e' * floats.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*floats)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:float_be] }
        let(:data)  { floats.pack('g' * floats.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*floats)
        end
      end
    end

    context "when the type has size of 8" do
      let(:doubles) { [1.2, -3.4, 5.6, -7.8, 9.0] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:double_le] }
        let(:data)  { doubles.pack('E' * doubles.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*doubles)
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:double_be] }
        let(:data)  { doubles.pack('G' * doubles.length) }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*doubles)
        end
      end
    end

    context "when the given data does not define #each_byte" do
      it do
        expect {
          subject.each_float(Object.new).to_a
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#each" do
    context "when the given data does not define #each_byte" do
      it do
        expect {
          subject.each(Object.new).to_a
        }.to raise_error(ArgumentError)
      end
    end
  end
end
