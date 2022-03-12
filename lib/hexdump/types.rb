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

    int8:  Type::Int8.new,
    uint8: Type::UInt8.new,

    int16:     Type::Int16.new,
    int16_le:  Type::Int16.new(endian: :little),
    int16_be:  Type::Int16.new(endian: :big),
    int16_ne:  Type::Int16.new(endian: :big),

    uint16:    Type::UInt16.new,
    uint16_le: Type::UInt16.new(endian: :little),
    uint16_be: Type::UInt16.new(endian: :big),
    uint16_ne: Type::UInt16.new(endian: :big),

    int32:     Type::Int32.new,
    int32_le:  Type::Int32.new(endian: :little),
    int32_be:  Type::Int32.new(endian: :big),
    int32_ne:  Type::Int32.new(endian: :big),

    uint32:    Type::UInt32.new,
    uint32_le: Type::UInt32.new(endian: :little),
    uint32_be: Type::UInt32.new(endian: :big),
    uint32_ne: Type::UInt32.new(endian: :big),

    int64:        Type::Int64.new,
    int64_le:     Type::Int64.new(endian: :little),
    int64_be:     Type::Int64.new(endian: :big),
    int64_ne:     Type::Int64.new(endian: :big),

    uint64:       Type::UInt64.new,
    uint64_le:    Type::UInt64.new(endian: :little),
    uint64_be:    Type::UInt64.new(endian: :big),
    uint64_ne:    Type::UInt64.new(endian: :big),

    float32:    Type::Float32.new,
    float32_le: Type::Float32.new(endian: :little),
    float32_be: Type::Float32.new(endian: :big),
    float32_ne: Type::Float32.new(endian: :big),

    float64:    Type::Float64.new,
    float64_le: Type::Float64.new(endian: :little),
    float64_be: Type::Float64.new(endian: :big),
    float64_ne: Type::Float64.new(endian: :big),
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

  TYPES[:long]    = TYPES[:int64]
  TYPES[:long_le] = TYPES[:int64_le]
  TYPES[:long_be] = TYPES[:int64_be]
  TYPES[:long_ne] = TYPES[:int64_ne]

  TYPES[:ulong]    = TYPES[:uint64]
  TYPES[:ulong_le] = TYPES[:uint64_le]
  TYPES[:ulong_be] = TYPES[:uint64_be]
  TYPES[:ulong_ne] = TYPES[:uint64_ne]

  TYPES[:long_long]    = TYPES[:int64]
  TYPES[:long_long_le] = TYPES[:int64_le]
  TYPES[:long_long_be] = TYPES[:int64_be]
  TYPES[:long_long_ne] = TYPES[:int64_ne]

  TYPES[:ulong_long]    = TYPES[:uint64]
  TYPES[:ulong_long_le] = TYPES[:uint64_le]
  TYPES[:ulong_long_be] = TYPES[:uint64_be]
  TYPES[:ulong_long_ne] = TYPES[:uint64_ne]

  TYPES[:float]    = TYPES[:float32]
  TYPES[:float_le] = TYPES[:float32_le]
  TYPES[:float_be] = TYPES[:float32_be]
  TYPES[:float_ne] = TYPES[:float32_ne]

  TYPES[:double]    = TYPES[:float64]
  TYPES[:double_le] = TYPES[:float64_le]
  TYPES[:double_be] = TYPES[:float64_be]
  TYPES[:double_ne] = TYPES[:float64_ne]
end
