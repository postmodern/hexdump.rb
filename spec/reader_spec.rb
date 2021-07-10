require 'spec_helper'
require 'hexdump/reader'
require 'hexdump/types'

describe Hexdump::Reader do
  describe "#each_slice" do
    context "when type has size of 1" do
      let(:chars) { %w[A B C D] }
      let(:data)  { chars.join }
      let(:type)  { Hexdump::TYPES[:int8] }

      subject { described_class.new(type) }

      it "must yield each consequetize character" do
        expect { |b|
          subject.each_slice(data,&b)
        }.to yield_successive_args(*chars)
      end
    end

    context "when type has size > 1" do
      let(:type)    { Hexdump::TYPES[:int16] }
      let(:strings) { %w[AA BB CC DD EE FF] }
      let(:data)    { strings.join }

      subject { described_class.new(type) }

      it "must yield each slice of the String" do
        expect { |b|
          subject.each_slice(data,&b)
        }.to yield_successive_args(*strings)
      end

      it "must yield a new String instance for each slice" do
        yielded_object_ids = []

        subject.each_slice(data) do |slice|
          yielded_object_ids << slice.object_id
        end

        expect(yielded_object_ids.uniq).to eq(yielded_object_ids)
      end

      context "when the given data is not evenly divisible by the type's size" do
        let(:type)    { Hexdump::TYPES[:int32] }
        let(:strings) { %w[AABB CCDD E] }
        let(:data)    { strings.join }

        it "must yield the reamining data" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args('AABB', 'CCDD', "E")
        end
      end
    end
  end

  describe "#each_uint" do
    context "when the type has size of 1" do
      let(:bytes) { [0x41, 0x42, 0x43, 0x44] }
      let(:raw)   { bytes.map(&:chr) }
      let(:data)  { raw.join }
      let(:type)  { Hexdump::TYPES[:int8] }

      subject { described_class.new(type) }

      it "must yield each byte" do
        expect { |b|
          subject.each_uint(data,&b)
        }.to yield_successive_args(*raw.zip(bytes))
      end
    end

    context "when the type has size of 2" do
      let(:uints) { [0xfa01, 0xfb02, 0xfc03, 0xfd04] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint16_le] }
        let(:raw)   { uints.map { |uint| [uint].pack('S<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11".encode(Encoding::BINARY) }

          it "must yield remaining bytes and the partially decoded uint" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint16_be] }
        let(:raw)   { uints.map { |uint| [uint].pack('S>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11".encode(Encoding::BINARY) }

          it "must yield remaining bytes and the partially decoded uint" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
        end
      end
    end

    context "when the type has size of 4" do
      let(:uints) { [0xffeedd01, 0xffccbb02, 0xffaa9903, 0xff887704] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint32_le] }
        let(:raw)   { uints.map { |uint| [uint].pack('L<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11\x22\x33".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint32_be] }
        let(:raw)   { uints.map { |uint| [uint].pack('L>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11\x22\x33".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
        end
      end
    end

    context "when the type has size of 8" do
      let(:uints) { [0xffffffff11223344, 0xffffffff55667788, 0xffffffff99aabbcc, 0xffffffffddeeff00] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:uint64_le] }
        let(:raw)   { uints.map { |uint| [uint].pack('Q<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11\x22\x33\x44\x55\x66\x77".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:uint64_be] }
        let(:raw)   { uints.map { |uint| [uint].pack('Q>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_uint(data,&b)
          }.to yield_successive_args(*raw.zip(uints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x11\x22\x33\x44\x55\x66\x77".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end
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

  describe "#each_int" do
    context "when the type has size of 1" do
      let(:ints) { [0x01, -0x02, 0x03, -0x04] }
      let(:type)  { Hexdump::TYPES[:int8] }
      let(:raw)   { ints.map { |int| [int].pack('c') } }
      let(:data)  { raw.join }

      subject { described_class.new(type) }

      it "must decode the bytes" do
        expect { |b|
          subject.each_int(data,&b)
        }.to yield_successive_args(*raw.zip(ints))
      end
    end

    context "when the type has size of 2" do
      let(:ints) { [0x0001, -0x0002, 0x0003, -0x0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int16_le] }
        let(:raw)   { ints.map { |int| [int].pack('s<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int16_be] }
        let(:raw)   { ints.map { |int| [int].pack('s>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end
    end

    context "when the type has size of 4" do
      let(:ints) { [0x00aa0001, -0x00bb0002, 0x00cc0003, -0x00dd0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int32_le] }
        let(:raw)   { ints.map { |int| [int].pack('l<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int32_be] }
        let(:raw)   { ints.map { |int| [int].pack('l>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end
    end

    context "when the type has size of 8" do
      let(:ints) { [0x1122334400aa0001, -0x1122334400bb0002, 0x1122334400cc0003, -0x1122334400dd0004] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:int64_le] }
        let(:raw)   { ints.map { |int| [int].pack('q<') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03\x04\x05\x06\x07".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:int64_be] }
        let(:raw)   { ints.map { |int| [int].pack('q>') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_int(data,&b)
          }.to yield_successive_args(*raw.zip(ints))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03\x04\x05\x06\x07".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end
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
        let(:raw)   { floats.map { |float| [float].pack('e') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*raw.zip(floats))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:float_be] }
        let(:raw)   { floats.map { |float| [float].pack('g') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*raw.zip(floats))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end
    end

    context "when the type has size of 8" do
      let(:floats) { [1.2, -3.4, 5.6, -7.8, 9.0] }

      context "when the type is little-endian" do
        let(:type)  { Hexdump::TYPES[:double_le] }
        let(:raw)   { floats.map { |float| [float].pack('E') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in little-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*raw.zip(floats))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03\x04\x05\x06\x07".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end
        end
      end

      context "when the type is big-endian" do
        let(:type)  { Hexdump::TYPES[:double_be] }
        let(:raw)   { floats.map { |float| [float].pack('G') } }
        let(:data)  { raw.join }

        subject { described_class.new(type) }

        it "must decode the bytes in big-endian order" do
          expect { |b|
            subject.each_float(data,&b)
          }.to yield_successive_args(*raw.zip(floats))
        end

        context "but there is not enough bytes to decode a value" do
          let(:data) { "\x01\x02\x03\x04\x05\x06\x07".encode(Encoding::BINARY) }

          it "must yield nil and the remaining bytes" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end
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
