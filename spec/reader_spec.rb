require 'spec_helper'
require 'hexdump/reader'
require 'hexdump/types'

describe Hexdump::Reader do
  describe "#initialize" do
    let(:type)  { Hexdump::TYPES[:uint8] }

    subject { described_class.new(type) }

    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    it "must default #offset to nil" do
      expect(subject.offset).to be(nil)
    end

    it "must default #length to nil" do
      expect(subject.length).to be(nil)
    end

    it "must default #zero_pad? to false" do
      expect(subject.zero_pad?).to be(false)
    end

    context "when offset: is given" do
      let(:offset) { 2 }

      subject { described_class.new(type, offset: offset) }

      it "must set #offset" do
        expect(subject.offset).to eq(offset)
      end
    end

    context "when length: is given" do
      let(:length) { 256 }

      subject { described_class.new(type, length: length) }

      it "must set #length" do
        expect(subject.length).to eq(length)
      end
    end

    context "when zero_pad: is true" do
      subject { described_class.new(type, zero_pad: true) }

      it "must enable #zero_pad?" do
        expect(subject.zero_pad?).to be(true)
      end
    end
  end

  describe "#each_byte" do
    let(:type)  { Hexdump::TYPES[:uint8] }

    subject { described_class.new(type) }

    let(:chars) { %w[A B C D] }
    let(:data)  { chars.join  }
    let(:bytes) { data.bytes  }

    it "must yield each byte from the given data" do
      expect { |b|
        subject.each_byte(data,&b)
      }.to yield_successive_args(*bytes)
    end

    context "when #offset is > 0" do
      let(:offset)  { 2 }
      let(:bytes) { data.bytes[offset..-1] }

      subject { described_class.new(type, offset: offset) }

      it "must offset the first N bytes before yielding any bytes" do
        expect { |b|
          subject.each_byte(data,&b)
        }.to yield_successive_args(*bytes)
      end
    end

    context "when #length is set" do
      let(:length) { 3 }
      let(:bytes) { data.bytes[0,length] }

      subject { described_class.new(type, length: length) }

      it "must read at most N bytes" do
        expect { |b|
          subject.each_byte(data,&b)
        }.to yield_successive_args(*bytes)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each_byte(data)).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#each_slice" do
    context "when type has size of 1" do
      let(:type)  { Hexdump::TYPES[:int8] }
      let(:chars) { %w[A B C D]           }
      let(:data)  { "ABCD"                }

      subject { described_class.new(type) }

      it "must yield each consequetize character" do
        expect { |b|
          subject.each_slice(data,&b)
        }.to yield_successive_args(*chars)
      end

      context "and when #offset is > 0" do
        let(:offset)  { 2       }
        let(:chars) { %w[C D] }

        subject { described_class.new(type, offset: offset) }

        it "must offset the first N bytes before reading each character" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args(*chars)
        end
      end

      context "and when #length is set" do
        let(:length) { 3         }
        let(:chars) { %w[A B C] }

        subject { described_class.new(type, length: length) }

        it "must read at most N bytes" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args(*chars)
        end
      end
    end

    context "when type has size > 1" do
      let(:type)   { Hexdump::TYPES[:int16] }
      let(:slices) { %w[AA BB CC DD EE FF]  }
      let(:data)   { "AABBCCDDEEFF"         }

      subject { described_class.new(type) }

      it "must yield each slice of the String" do
        expect { |b|
          subject.each_slice(data,&b)
        }.to yield_successive_args(*slices)
      end

      it "must yield a new String instance for each slice" do
        yielded_object_ids = []

        subject.each_slice(data) do |slice|
          yielded_object_ids << slice.object_id
        end

        expect(yielded_object_ids.uniq).to eq(yielded_object_ids)
      end

      context "and when #offset is > 0" do
        let(:offset)   { 3 }
        let(:slices) { %w[BC CD DE EF F] }

        subject { described_class.new(type, offset: offset) }

        it "must offset the first N bytes before reading each slice" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args(*slices)
        end
      end

      context "and when #length is set" do
        let(:length)  { 7 }
        let(:slices) { %w[AA BB CC D] }

        subject { described_class.new(type, length: length) }

        it "must read at most N bytes" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args(*slices)
        end
      end

      context "when the given data is not evenly divisible by the type's size" do
        let(:type)   { Hexdump::TYPES[:int32] }
        let(:slices) { %w[AABB CCDD E]        }
        let(:data)   { "AABBCCDDE"            }

        it "must yield the reamining data" do
          expect { |b|
            subject.each_slice(data,&b)
          }.to yield_successive_args('AABB', 'CCDD', "E")
        end

        context "but #zero_pad? is true" do
          subject { described_class.new(type, zero_pad: true) }

          it "must zero out the rest of the buffer" do
            expect { |b|
              subject.each_slice(data,&b)
            }.to yield_successive_args('AABB', 'CCDD', "E\0\0\0")
          end
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

          it "must yield remaining bytes and nil" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x0011)
            end
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

          it "must yield remaining bytes and nil" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x1100)
            end
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

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x00332211)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x11223300)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x0077665544332211)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_uint(data,&b)
            }.to yield_with_args(data,nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded uint" do
              expect { |b|
                subject.each_uint(data,&b)
              }.to yield_with_args("#{data}\x00",0x1122334455667700)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x01)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x0100)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x00030201)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x01020300)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_int(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x0007060504030201)
            end
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

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_int(data,&b)
              }.to yield_with_args("#{data}\x00",0x0102030405060700)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_float(data,&b)
              }.to yield_with_args("#{data}\x00",2.7622535458617227e-40)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_float(data,&b)
              }.to yield_with_args("#{data}\x00",2.387938139551892e-38)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_float(data,&b)
              }.to yield_with_args("#{data}\x00",9.76739841864353e-309)
            end
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

          it "must yield the remaining bytes and nil" do
            expect { |b|
              subject.each_float(data,&b)
            }.to yield_with_args(data, nil)
          end

          context "but #zero_pad? is true" do
            subject { described_class.new(type, zero_pad: true) }

            it "must yield the zero-padded data and partially decoded int" do
              expect { |b|
                subject.each_float(data,&b)
              }.to yield_with_args("#{data}\x00",8.207880399131826e-304)
            end
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
