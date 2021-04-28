require 'spec_helper'
require 'hexdump/types'

describe "Hexdump::TYPES" do
  subject { Hexdump::TYPES }

  describe "byte" do
    subject { super()[:byte] }

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
    subject { super()[:short] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "short_le" do
    subject { super()[:short_le] }

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

  describe "short_be" do
    subject { super()[:short_be] }

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

  describe "short_ne" do
    subject { super()[:short_ne] }

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

  describe "ushort" do
    subject { super()[:ushort] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 2" do
      expect(subject.size).to eq(2)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "ushort_le" do
    subject { super()[:ushort_le] }

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

  describe "ushort_be" do
    subject { super()[:ushort_be] }

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

  describe "ushort_ne" do
    subject { super()[:ushort_ne] }

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
    subject { super()[:int] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "long" do
    subject { super()[:long] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "long_le" do
    subject { super()[:long_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 1" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "long_be" do
    subject { super()[:long_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 1" do
      expect(subject.size).to eq(4)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "long_ne" do
    subject { super()[:long_ne] }

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

  describe "uint" do
    subject { super()[:uint] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "ulong" do
    subject { super()[:ulong] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 4" do
      expect(subject.size).to eq(4)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "ulong_le" do
    subject { super()[:ulong_le] }

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

  describe "ulong_be" do
    subject { super()[:ulong_be] }

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

  describe "ulong_ne" do
    subject { super()[:ulong_ne] }

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
    subject { super()[:longlong] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end
  end

  describe "longlong_le" do
    subject { super()[:longlong_le] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 1" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be little" do
      expect(subject.endian).to eq(:little)
    end
  end

  describe "longlong_be" do
    subject { super()[:longlong_be] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::Int) }

    it "size must equal 1" do
      expect(subject.size).to eq(8)
    end

    it "must be signed" do
      expect(subject.signed?).to be(true)
    end

    it "endian must be big" do
      expect(subject.endian).to eq(:big)
    end
  end

  describe "longlong_ne" do
    subject { super()[:longlong_ne] }

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

  describe "ulonglong" do
    subject { super()[:ulonglong] }

    it { expect(subject).to_not be(nil) }
    it { expect(subject).to be_kind_of(Hexdump::Type::UInt) }

    it "size must equal 8" do
      expect(subject.size).to eq(8)
    end

    it "must not be signed" do
      expect(subject.signed?).to be(false)
    end
  end

  describe "ulonglong_le" do
    subject { super()[:ulonglong_le] }

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

  describe "ulonglong_be" do
    subject { super()[:ulonglong_be] }

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

  describe "ulonglong_ne" do
    subject { super()[:ulonglong_ne] }

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
end
