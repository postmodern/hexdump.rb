require 'hexdump/type'

module Hexdump
  #
  # @api private
  #
  TYPES = {
    int8:  Type::Int.new(size: 1),
    uint8: Type::UInt.new(size: 1),

    byte:  Type::UInt.new(size: 1),

    char:  Type::Int.new(size: 1),
    uchar: Type::UInt.new(size: 1),

    int16:     Type::Int.new(size: 2),
    int16_le:  Type::Int.new(size: 2, endian: :little),
    int16_be:  Type::Int.new(size: 2, endian: :big),
    int16_ne:  Type::Int.new(size: 2, endian: :big),

    uint16:    Type::UInt.new(size: 2),
    uint16_le: Type::UInt.new(size: 2, endian: :little),
    uint16_be: Type::UInt.new(size: 2, endian: :big),
    uint16_ne: Type::UInt.new(size: 2, endian: :big),

    short:     Type::Int.new(size: 2),
    short_le:  Type::Int.new(size: 2, endian: :little),
    short_be:  Type::Int.new(size: 2, endian: :big),
    short_ne:  Type::Int.new(size: 2, endian: :big),

    ushort:    Type::UInt.new(size: 2),
    ushort_le: Type::UInt.new(size: 2, endian: :little),
    ushort_be: Type::UInt.new(size: 2, endian: :big),
    ushort_ne: Type::UInt.new(size: 2, endian: :big),

    int32:     Type::Int.new(size: 4),
    int32_le:  Type::Int.new(size: 4, endian: :little),
    int32_be:  Type::Int.new(size: 4, endian: :big),
    int32_ne:  Type::Int.new(size: 4, endian: :big),

    uint32:    Type::UInt.new(size: 4),
    uint32_le: Type::UInt.new(size: 4, endian: :little),
    uint32_be: Type::UInt.new(size: 4, endian: :big),
    uint32_ne: Type::UInt.new(size: 4, endian: :big),

    int:       Type::Int.new(size: 4),
    long:      Type::Int.new(size: 4),
    long_le:   Type::Int.new(size: 4, endian: :little),
    long_be:   Type::Int.new(size: 4, endian: :big),
    long_ne:   Type::Int.new(size: 4, endian: :big),

    uint:      Type::UInt.new(size: 4),
    ulong:     Type::UInt.new(size: 4),
    ulong_le:  Type::UInt.new(size: 4, endian: :little),
    ulong_be:  Type::UInt.new(size: 4, endian: :big),
    ulong_ne:  Type::UInt.new(size: 4, endian: :big),

    int64:        Type::Int.new(size: 8),
    int64_le:     Type::Int.new(size: 8, endian: :little),
    int64_be:     Type::Int.new(size: 8, endian: :big),
    int64_ne:     Type::Int.new(size: 8, endian: :big),

    uint64:       Type::UInt.new(size: 8),
    uint64_le:    Type::UInt.new(size: 8, endian: :little),
    uint64_be:    Type::UInt.new(size: 8, endian: :big),
    uint64_ne:    Type::UInt.new(size: 8, endian: :big),

    longlong:     Type::Int.new(size: 8),
    longlong_le:  Type::Int.new(size: 8, endian: :little),
    longlong_be:  Type::Int.new(size: 8, endian: :big),
    longlong_ne:  Type::Int.new(size: 8, endian: :big),

    ulonglong:    Type::UInt.new(size: 8),
    ulonglong_le: Type::UInt.new(size: 8, endian: :little),
    ulonglong_be: Type::UInt.new(size: 8, endian: :big),
    ulonglong_ne: Type::UInt.new(size: 8, endian: :big),

    float:    Type::Float.new(size: 4),
    float_le: Type::Float.new(size: 4, endian: :little),
    float_be: Type::Float.new(size: 4, endian: :big),
    float_ne: Type::Float.new(size: 4, endian: :big),

    double:    Type::Float.new(size: 8),
    double_le: Type::Float.new(size: 8, endian: :little),
    double_be: Type::Float.new(size: 8, endian: :big),
    double_ne: Type::Float.new(size: 8, endian: :big),
  }
end
