require 'spec_helper'
require 'hexdump/types'

describe "Hexdump::TYPES" do
  subject { Hexdump::TYPES }

  describe "byte" do
    it "must be an alias to uint8" do
      expect(subject[:byte]).to be(subject[:uint8])
    end
  end

  describe "char" do
    subject { super()[:char] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Char) }

    it "size must equal 1" do
      expect(subject.size).to eq(1)
    end

    it "must not have endian-ness" do
      expect(subject.endian).to be(nil)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "uchar" do
    subject { super()[:uchar] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UChar) }

    it "size must equal 1" do
      expect(subject.size).to eq(1)
    end

    it "must not have endian-ness" do
      expect(subject.endian).to be(nil)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "int8" do
    subject { super()[:int8] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 1" do
      expect(subject.size).to eq(1)
    end

    it "must not have endian-ness" do
      expect(subject.endian).to be(nil)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "uint8" do
    subject { super()[:uint8] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 1" do
      expect(subject.size).to eq(1)
    end

    it "must not have endian-ness" do
      expect(subject.endian).to be(nil)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "int16" do
    subject { super()[:int16] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "int16_le" do
    subject { super()[:int16_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "int16_be" do
    subject { super()[:int16_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "int16_ne" do
    subject { super()[:int16_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint16" do
    subject { super()[:uint16] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "uint16_le" do
    subject { super()[:uint16_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "uint16_be" do
    subject { super()[:uint16_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint16_ne" do
    subject { super()[:uint16_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "short" do
    it "must be an alias to int16" do
      expect(subject[:short]).to be(subject[:int16])
    end
  end

  describe "short_le" do
    it "must be an alias to int16_le" do
      expect(subject[:short_le]).to be(subject[:int16_le])
    end
  end

  describe "short_be" do
    it "must be an alias to int16_be" do
      expect(subject[:short_be]).to be(subject[:int16_be])
    end
  end

  describe "short_ne" do
    it "must be an alias to int16_ne" do
      expect(subject[:short_ne]).to be(subject[:int16_ne])
    end
  end

  describe "ushort" do
    it "must be an alias to uint16" do
      expect(subject[:ushort]).to be(subject[:uint16])
    end
  end

  describe "ushort_le" do
    it "must be an alias to uint16_le" do
      expect(subject[:ushort_le]).to be(subject[:uint16_le])
    end
  end

  describe "ushort_be" do
    it "must be an alias to uint16_be" do
      expect(subject[:ushort_be]).to be(subject[:uint16_be])
    end
  end

  describe "ushort_ne" do
    it "must be an alias to uint16_ne" do
      expect(subject[:ushort_ne]).to be(subject[:uint16_ne])
    end
  end

  describe "int32" do
    subject { super()[:int32] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "int32_le" do
    subject { super()[:int32_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "int32_be" do
    subject { super()[:int32_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "int32_ne" do
    subject { super()[:int32_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint32" do
    subject { super()[:uint32] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "uint32_le" do
    subject { super()[:uint32_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "uint32_be" do
    subject { super()[:uint32_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint32_ne" do
    subject { super()[:uint32_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "int" do
    it "must be an alias to int32" do
      expect(subject[:int]).to be(subject[:int32])
    end
  end

  describe "int_le" do
    it "must be an alias to int32_le" do
      expect(subject[:int_le]).to be(subject[:int32_le])
    end
  end

  describe "int_be" do
    it "must be an alias to int32_be" do
      expect(subject[:int_be]).to be(subject[:int32_be])
    end
  end

  describe "int_ne" do
    it "must be an alias to int32_ne" do
      expect(subject[:int_ne]).to be(subject[:int32_ne])
    end
  end

  describe "long" do
    it "must be an alias to int32" do
      expect(subject[:long]).to be(subject[:int32])
    end
  end

  describe "long_le" do
    it "must be an alias to int32_le" do
      expect(subject[:long_le]).to be(subject[:int32_le])
    end
  end

  describe "long_be" do
    it "must be an alias to int32_be" do
      expect(subject[:long_be]).to be(subject[:int32_be])
    end
  end

  describe "long_ne" do
    it "must be an alias to int32_ne" do
      expect(subject[:long_ne]).to be(subject[:int32_ne])
    end
  end

  describe "uint" do
    it "must be an alias to uint32" do
      expect(subject[:uint]).to be(subject[:uint32])
    end
  end

  describe "uint_le" do
    it "must be an alias to uint32_le" do
      expect(subject[:uint_le]).to be(subject[:uint32_le])
    end
  end

  describe "uint_be" do
    it "must be an alias to uint32_be" do
      expect(subject[:uint_be]).to be(subject[:uint32_be])
    end
  end

  describe "uint_ne" do
    it "must be an alias to uint32_ne" do
      expect(subject[:uint_ne]).to be(subject[:uint32_ne])
    end
  end

  describe "ulong" do
    it "must be an alias to uint32" do
      expect(subject[:ulong]).to be(subject[:uint32])
    end
  end

  describe "ulong_le" do
    it "must be an alias to uint32_le" do
      expect(subject[:ulong_le]).to be(subject[:uint32_le])
    end
  end

  describe "ulong_be" do
    it "must be an alias to uint32_be" do
      expect(subject[:ulong_be]).to be(subject[:uint32_be])
    end
  end

  describe "ulong_ne" do
    it "must be an alias to uint32_ne" do
      expect(subject[:ulong_ne]).to be(subject[:uint32_ne])
    end
  end

  describe "int64" do
    subject { super()[:int64] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "int64_le" do
    subject { super()[:int64_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "int64_be" do
    subject { super()[:int64_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "int64_ne" do
    subject { super()[:int64_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint64" do
    subject { super()[:uint64] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "uint64_le" do
    subject { super()[:uint64_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "uint64_be" do
    subject { super()[:uint64_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "uint64_ne" do
    subject { super()[:uint64_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(false)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "longlong" do
    it "must be an alias to int64" do
      expect(subject[:longlong]).to be(subject[:int64])
    end
  end

  describe "longlong_le" do
    it "must be an alias to int64_le" do
      expect(subject[:longlong_le]).to be(subject[:int64_le])
    end
  end

  describe "longlong_be" do
    it "must be an alias to int64_be" do
      expect(subject[:longlong_be]).to be(subject[:int64_be])
    end
  end

  describe "longlong_ne" do
    it "must be an alias to int64_ne" do
      expect(subject[:longlong_ne]).to be(subject[:int64_ne])
    end
  end

  describe "ulonglong" do
    it "must be an alias to uint64" do
      expect(subject[:ulonglong]).to be(subject[:uint64])
    end
  end

  describe "ulonglong_le" do
    it "must be an alias to uint64_le" do
      expect(subject[:ulonglong_le]).to be(subject[:uint64_le])
    end
  end

  describe "ulonglong_be" do
    it "must be an alias to uint64_be" do
      expect(subject[:ulonglong_be]).to be(subject[:uint64_be])
    end
  end

  describe "ulonglong_ne" do
    it "must be an alias to uint64_ne" do
      expect(subject[:ulonglong_ne]).to be(subject[:uint64_ne])
    end
  end

  describe "#float" do
    subject { super()[:float] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "#float_le" do
    subject { super()[:float_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "#float_be" do
    subject { super()[:float_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "#float_ne" do
    subject { super()[:float_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "#double" do
    subject { super()[:double] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "#double_le" do
    subject { super()[:double_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "#double_be" do
    subject { super()[:double_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "#double_ne" do
    subject { super()[:double_ne] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Float) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "float32" do
    it "must be an alias to float" do
      expect(subject[:float32]).to be(subject[:float])
    end
  end

  describe "float32_le" do
    it "must be an alias to float_le" do
      expect(subject[:float32_le]).to be(subject[:float_le])
    end
  end

  describe "float32_be" do
    it "must be an alias to float_be" do
      expect(subject[:float32_be]).to be(subject[:float_be])
    end
  end

  describe "float32_ne" do
    it "must be an alias to float_ne" do
      expect(subject[:float32_ne]).to be(subject[:float_ne])
    end
  end

  describe "float64" do
    it "must be an alias to double" do
      expect(subject[:float64]).to be(subject[:double])
    end
  end

  describe "float64_le" do
    it "must be an alias to double_le" do
      expect(subject[:float64_le]).to be(subject[:double_le])
    end
  end

  describe "float64_be" do
    it "must be an alias to double_be" do
      expect(subject[:float64_be]).to be(subject[:double_be])
    end
  end

  describe "float64_ne" do
    it "must be an alias to double_ne" do
      expect(subject[:float64_ne]).to be(subject[:double_ne])
    end
  end
end
