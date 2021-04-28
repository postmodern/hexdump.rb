require 'hexdump/type'

module Hexdump
  #
  # @api private
  #
  # @since 1.0.0
  #
  TYPES = {
    char:  Type::Char.new,
    uchar: Type::UChar.new,

    int8:  Type::Int.new(size: 1, endian: nil),
    uint8: Type::UInt.new(size: 1, endian: nil),

    int16:     Type::Int.new(size: 2),
    int16_le:  Type::Int.new(size: 2, endian: :little),
    int16_be:  Type::Int.new(size: 2, endian: :big),
    int16_ne:  Type::Int.new(size: 2, endian: :big),

    uint16:    Type::UInt.new(size: 2),
    uint16_le: Type::UInt.new(size: 2, endian: :little),
    uint16_be: Type::UInt.new(size: 2, endian: :big),
    uint16_ne: Type::UInt.new(size: 2, endian: :big),

    int32:     Type::Int.new(size: 4),
    int32_le:  Type::Int.new(size: 4, endian: :little),
    int32_be:  Type::Int.new(size: 4, endian: :big),
    int32_ne:  Type::Int.new(size: 4, endian: :big),

    uint32:    Type::UInt.new(size: 4),
    uint32_le: Type::UInt.new(size: 4, endian: :little),
    uint32_be: Type::UInt.new(size: 4, endian: :big),
    uint32_ne: Type::UInt.new(size: 4, endian: :big),

    int64:        Type::Int.new(size: 8),
    int64_le:     Type::Int.new(size: 8, endian: :little),
    int64_be:     Type::Int.new(size: 8, endian: :big),
    int64_ne:     Type::Int.new(size: 8, endian: :big),

    uint64:       Type::UInt.new(size: 8),
    uint64_le:    Type::UInt.new(size: 8, endian: :little),
    uint64_be:    Type::UInt.new(size: 8, endian: :big),
    uint64_ne:    Type::UInt.new(size: 8, endian: :big),

    float:    Type::Float.new(size: 4),
    float_le: Type::Float.new(size: 4, endian: :little),
    float_be: Type::Float.new(size: 4, endian: :big),
    float_ne: Type::Float.new(size: 4, endian: :big),

    double:    Type::Float.new(size: 8),
    double_le: Type::Float.new(size: 8, endian: :little),
    double_be: Type::Float.new(size: 8, endian: :big),
    double_ne: Type::Float.new(size: 8, endian: :big),
  }

  TYPES[:byte]   = TYPES[:uint8]

  TYPES[:short]    = TYPES[:int16]
  TYPES[:short_le] = TYPES[:int16_le]
  TYPES[:short_be] = TYPES[:int16_be]
  TYPES[:short_ne] = TYPES[:int16_ne]

  TYPES[:ushort]    = TYPES[:uint16]
  TYPES[:ushort_le] = TYPES[:uint16_le]
  TYPES[:ushort_be] = TYPES[:uint16_be]
  TYPES[:ushort_ne] = TYPES[:uint16_ne]

  TYPES[:int]    = TYPES[:int32]
  TYPES[:int_le] = TYPES[:int32_le]
  TYPES[:int_be] = TYPES[:int32_be]
  TYPES[:int_ne] = TYPES[:int32_ne]

  TYPES[:uint]    = TYPES[:uint32]
  TYPES[:uint_le] = TYPES[:uint32_le]
  TYPES[:uint_be] = TYPES[:uint32_be]
  TYPES[:uint_ne] = TYPES[:uint32_ne]

  TYPES[:long]    = TYPES[:int32]
  TYPES[:long_le] = TYPES[:int32_le]
  TYPES[:long_be] = TYPES[:int32_be]
  TYPES[:long_ne] = TYPES[:int32_ne]

  TYPES[:ulong]    = TYPES[:uint32]
  TYPES[:ulong_le] = TYPES[:uint32_le]
  TYPES[:ulong_be] = TYPES[:uint32_be]
  TYPES[:ulong_ne] = TYPES[:uint32_ne]

  TYPES[:longlong]    = TYPES[:int64]
  TYPES[:longlong_le] = TYPES[:int64_le]
  TYPES[:longlong_be] = TYPES[:int64_be]
  TYPES[:longlong_ne] = TYPES[:int64_ne]

  TYPES[:ulonglong]    = TYPES[:uint64]
  TYPES[:ulonglong_le] = TYPES[:uint64_le]
  TYPES[:ulonglong_be] = TYPES[:uint64_be]
  TYPES[:ulonglong_ne] = TYPES[:uint64_ne]
end
