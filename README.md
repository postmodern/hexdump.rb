# hexdump.rb

[![CI](https://github.com/postmodern/hexdump.rb/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/hexdump.rb/actions/workflows/ruby.yml)

* [Source](https://github.com/postmodern/hexdump.rb)
* [Issues](https://github.com/postmodern/hexdump.rb/issues)
* [Documentation](http://rubydoc.info/gems/hexdump/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Simple and Fast hexdumping for Ruby.

## Features

* Supports printing ASCII, hexadecimal, decimal, octal and binary bytes.
* Supports hexdumping bytes, characters, signed/unsigned integers,
  floating-point numbers, and in little/big/network endian byte orders:
  * `byte` - ASCII byte (default)
  * `char` - signed 8bit ASCII character
  * `uchar` - unsigned 8bit ASCII character
  * `int8` - signed 8bit integer
  * `uint8` - unsigned 8bit integer
  * `int16` - signed 16bit integer
  * `int16_le` - signed 16bit integer (little endian)
  * `int16_be` - signed 16bit integer (big nedian)
  * `int16_ne` - signed 16bit integer (network endian)
  * `uint16` - unsigned 16bit integer
  * `uint16_le` - unsigned 16bit integer (little endian)
  * `uint16_be` - unsigned 16bit integer (big nedian)
  * `uint16_ne` - unsigned 16bit integer (network endian)
  * `int32` - signed 32bit integer
  * `int32_le` - signed 32bit integer (little endian)
  * `int32_be` - signed 32bit integer (big nedian)
  * `int32_ne` - signed 32bit integer (network endian)
  * `uint32` - unsigned 32bit integer
  * `uint32_le` - unsigned 32bit integer (little endian)
  * `uint32_be` - unsigned 32bit integer (big nedian)
  * `uint32_ne` - unsigned 32bit integer (network endian)
  * `int64` - signed 64bit integer
  * `int64_le` - signed 64bit integer (little endian)
  * `int64_be` - signed 64bit integer (big nedian)
  * `int64_ne` - signed 64bit integer (network endian)
  * `uint64` - unsigned 64bit integer
  * `uint64_le` - unsigned 64bit integer (little endian)
  * `uint64_be` - unsigned 64bit integer (big nedian)
  * `uint64_ne` - unsigned 64bit integer (network endian)
  * `float` - single precision 32bit floating-point number
  * `float_le` - single precision 32bit floating-point number (little endian)
  * `float_be` - single precision 32bit floating-point number (big endian)
  * `float_ne` - single precision 32bit floating-point number (network endian)
  * `double` - single precision 64bit floating-point number
  * `double_le` - single precision 64bit floating-point number (little endian)
  * `double_be` - single precision 64bit floating-point number (big endian)
  * `double_ne` - single precision 64bit floating-point number (network endian)
* Can hexdump any Object supporting the `each_byte` method.
* Can send the hexdump output to any Object supporting the `<<` method.
* Can yield each line of hexdump, instead of printing the output.
* Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
* Fast-ish.

## Examples

    require 'hexdump'

    Hexdump.dump("hello\0")
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006
    
    "hello\0".hexdump
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006

    File.open('dump.txt','w') do |file|
      data.hexdump(output: file)
    end

    # iterate over the hexdump lines
    "hello\0".hexdump do |index,hex,printable|
      index     # => 0
      hex       # => ["68", "65", "6c", "6c", "6f", "00"]
      printable # => ["h", "e", "l", "l", "o", "."]
    end
    # => 6

    # configure the width of the hexdump
    Hexdump.dump('A' * 30, columns: 10)
    # 00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 0000000a  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 00000014  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 0000001e

    Hexdump.dump("hello\0", type: :char)
    # 00000000    h   e   l   l   o  \0                                          |hello.|
    # 00000006

    Hexdump.dump("hello\0", base: 16)
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006

    Hexdump.dump("hello\0", base: 10)
    # 00000000  104 101 108 108 111   0                                          |hello.|
    # 00000006

    Hexdump.dump("hello\0", base: 8)
    # 00000000  0150 0145 0154 0154 0157 0000                                                    |hello.|
    # 00000006

    Hexdump.dump("hello\0", base: 2)
    # 00000000  01101000 01100101 01101100 01101100 01101111 00000000                                                                                            |hello.|
    # 00000006

    ("ABC" * 10).hexdump(type: :uint16_le)
    # 00000000  4241 4143 4342 4241 4143 4342 4241 4143  |䉁䅃䍂䉁䅃䍂䉁䅃|
    # 00000010  4342 4241 4143 4342 4241 4143 4342       |䍂䉁䅃䍂䉁䅃䍂|
    # 0000001e

## Install

    $ gem install hexdump

## Benchmarks

Benchmarks show {Hexdump.dump} processing 25M of data.

### Ruby 2.7.3

```
                                        user     system      total        real
Hexdump.dump (output)              10.283433   0.000748  10.284181 ( 10.328899)
Hexdump.dump width=256 (output)     8.803228   0.005973   8.809201 (  8.838375)
Hexdump.dump ascii=true (output)   10.740975   0.001903  10.742878 ( 10.779777)
Hexdump.dump word_size=2 (output)  15.163195   0.000989  15.164184 ( 15.220481)
Hexdump.dump word_size=4 (output)  14.279406   0.003840  14.283246 ( 14.345357)
Hexdump.dump word_size=8 (output)   7.715803   0.002879   7.718682 (  7.746389)
Hexdump.dump (block)                5.543268   0.000980   5.544248 (  5.561494)
Hexdump.dump width=256 (block)      5.438946   0.000000   5.438946 (  5.455742)
Hexdump.dump ascii=true (block)     6.082787   0.000924   6.083711 (  6.106234)
Hexdump.dump word_size=2 (block)   11.439610   0.000983  11.440593 ( 11.483788)
Hexdump.dump word_size=4 (block)   11.111633   0.000954  11.112587 ( 11.158416)
Hexdump.dump word_size=8 (block)    5.397569   0.002896   5.400465 (  5.426971)
```

### Ruby 3.0.1

```
                                        user     system      total        real
Hexdump.dump (output)              12.064022   0.001165  12.065187 ( 12.118272)
Hexdump.dump width=256 (output)    10.228743   0.009920  10.238663 ( 10.279783)
Hexdump.dump ascii=true (output)   12.532913   0.000000  12.532913 ( 12.582665)
Hexdump.dump word_size=2 (output)  17.685782   0.000000  17.685782 ( 17.770686)
Hexdump.dump word_size=4 (output)  15.835564   0.000000  15.835564 ( 15.917552)
Hexdump.dump word_size=8 (output)   8.436831   0.000000   8.436831 (  8.473445)
Hexdump.dump (block)                6.482589   0.000000   6.482589 (  6.504816)
Hexdump.dump width=256 (block)      6.360828   0.000000   6.360828 (  6.383705)
Hexdump.dump ascii=true (block)     6.911868   0.000000   6.911868 (  6.936795)
Hexdump.dump word_size=2 (block)   13.120488   0.000000  13.120488 ( 13.179957)
Hexdump.dump word_size=4 (block)   12.349516   0.000000  12.349516 ( 12.412972)
Hexdump.dump word_size=8 (block)    5.814830   0.000000   5.814830 (  5.837822)
```

### JRuby 9.2.16.0

```
                                        user     system      total        real
Hexdump.dump (output)              13.090000   0.240000  13.330000 ( 11.226466)
Hexdump.dump width=256 (output)     9.350000   0.030000   9.380000 (  9.165070)
Hexdump.dump ascii=true (output)   10.910000   0.050000  10.960000 ( 10.665791)
Hexdump.dump word_size=2 (output)  13.760000   0.150000  13.910000 ( 12.268307)
Hexdump.dump word_size=4 (output)  11.940000   0.090000  12.030000 ( 11.107564)
Hexdump.dump word_size=8 (output)   8.170000   0.040000   8.210000 (  7.419708)
Hexdump.dump (block)                7.840000   0.020000   7.860000 (  7.777749)
Hexdump.dump width=256 (block)      7.540000   0.000000   7.540000 (  7.466315)
Hexdump.dump ascii=true (block)     7.680000   0.010000   7.690000 (  7.622393)
Hexdump.dump word_size=2 (block)    9.830000   0.020000   9.850000 (  9.693596)
Hexdump.dump word_size=4 (block)    9.010000   0.020000   9.030000 (  8.998687)
Hexdump.dump word_size=8 (block)    5.740000   0.030000   5.770000 (  5.709127)
```

### TruffleRuby 21.0.0

```
                                        user     system      total        real
Hexdump.dump (output)              25.818995   0.855689  26.674684 ( 22.376015)
Hexdump.dump width=256 (output)    20.489077   0.125966  20.615043 ( 18.301748)
Hexdump.dump ascii=true (output)   25.214678   0.098018  25.312696 ( 21.714985)
Hexdump.dump word_size=2 (output)  28.380387   0.192277  28.572664 ( 23.736887)
Hexdump.dump word_size=4 (output)  31.348977   0.134854  31.483831 ( 27.710968)
Hexdump.dump word_size=8 (output)  18.850093   0.100256  18.950349 ( 13.921720)
Hexdump.dump (block)                7.792878   0.050542   7.843420 (  6.003789)
Hexdump.dump width=256 (block)      6.526531   0.015898   6.542429 (  5.777169)
Hexdump.dump ascii=true (block)     7.425399   0.030799   7.456198 (  5.705369)
Hexdump.dump word_size=2 (block)   12.629775   0.028653  12.658428 ( 11.115049)
Hexdump.dump word_size=4 (block)   20.372094   0.010807  20.382901 ( 19.758073)
Hexdump.dump word_size=8 (block)    8.828653   0.010889   8.839542 (  8.017241)
```

## Copyright

Copyright (c) 2011-2021 Hal Brodigan

See {file:LICENSE.txt} for details.
