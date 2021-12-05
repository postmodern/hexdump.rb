# hexdump.rb

[![CI](https://github.com/postmodern/hexdump.rb/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/hexdump.rb/actions/workflows/ruby.yml)
[![Gem Version](https://badge.fury.io/rb/hexdump.svg)](https://badge.fury.io/rb/hexdump)

* [Source](https://github.com/postmodern/hexdump.rb)
* [Issues](https://github.com/postmodern/hexdump.rb/issues)
* [Documentation](http://rubydoc.info/gems/hexdump/frames)

## Description

Fully Featured and Fast hexdumping for Ruby.

## Features

* Supports printing ASCII, hexadecimal, decimal, octal and binary bytes.
* Supports hexdumping bytes, characters, signed/unsigned integers,
  floating-point numbers, and in little/big/network endian byte orders:
  * `char` - signed 8bit ASCII character
  * `uchar` - unsigned 8bit ASCII character
  * `int8` - signed 8bit integer
  * `uin8` / `byte` - unsigned 8bit integer (default)
  * `int16` / `short` - signed 16bit integer
  * `int16_le` / `short_le` - signed 16bit integer (little endian)
  * `int16_be` / `short_be` - signed 16bit integer (big endian)
  * `int16_ne` / `short_ne` - signed 16bit integer (network endian)
  * `uint16` / `ushort` - unsigned 16bit integer
  * `uint16_le` / `ushort_le` - unsigned 16bit integer (little endian)
  * `uint16_be` / `ushort_be` - unsigned 16bit integer (big endian)
  * `uint16_ne` / `ushort_ne` - unsigned 16bit integer (network endian)
  * `int32` / `int` / `long` - signed 32bit integer
  * `int32_le` / `int_le` / `long_le` - signed 32bit integer (little endian)
  * `int32_be` / `int_be` / `long_be` - signed 32bit integer (big endian)
  * `int32_ne` / `int_ne` / `long_ne` - signed 32bit integer (network endian)
  * `uint32` / `uint` / `ulong` - unsigned 32bit integer
  * `uint32_le` / `uint_le` / `ulong_le` - unsigned 32bit integer
    (little endian)
  * `uint32_be` / `uint_be` / `ulong_be` - unsigned 32bit integer (big endian)
  * `uint32_ne` / `uint_ne` / `ulong_ne` - unsigned 32bit integer
    (network endian)
  * `int64` / `long_long` - signed 64bit integer
  * `int64_le` / `long_long_le` - signed 64bit integer (little endian)
  * `int64_be` / `long_long_be` - signed 64bit integer (big endian)
  * `int64_ne` / `long_long_ne` - signed 64bit integer (network endian)
  * `uint64` / `ulong_long` - unsigned 64bit integer
  * `uint64_le` / `ulong_long_le` - unsigned 64bit integer (little endian)
  * `uint64_be` / `ulong_long_be` - unsigned 64bit integer (big endian)
  * `uint64_ne` / `ulong_long_ne` - unsigned 64bit integer (network endian)
  * `float` - single precision 32bit floating-point number
  * `float_le` - single precision 32bit floating-point number (little endian)
  * `float_be` - single precision 32bit floating-point number (big endian)
  * `float_ne` - single precision 32bit floating-point number (network endian)
  * `double` - double precision 64bit floating-point number
  * `double_le` - double precision 64bit floating-point number (little endian)
  * `double_be` - double precision 64bit floating-point number (big endian)
  * `double_ne` - double precision 64bit floating-point number (network endian)
* Supports optionally skipping N bytes or reading at most N bytes of data.
* Supports optional zero-padding of the data.
* Supports omitting repeating rows with a `*`.
* Supports grouping columns together like GNU `hexdump -C`.
* Supports grouping characters together to align with the type's size.
* Supports displaying characters inline like GNU `hexdump -c`.
* Supports displaying UTF-8 characters or other character encodings.
* Supports ANSI styling and highlighting.
* Can hexdump any Object supporting the `each_byte` method.
* Can send the hexdump output to any Object supporting the `<<` method.
* Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
* Fast-ish.

## Requirements

* [Ruby] >= 2.0.0

[Ruby]: https://www.ruby-lang.org/

## Install

```shell
$ gem install hexdump
```

### gemspec

```ruby
gem.add_dependency 'hexdump', '~> 1.0'
```

### Gemfile

```ruby
gem 'hexdump', '~> 1.0'
```

## Examples

```ruby
require 'hexdump'

Hexdump.hexdump("hello\0")
# 00000000  68 65 6c 6c 6f 00                                |hello.|
# 00000006
```

### Core Extensions

```ruby
"hello\0".hexdump
# 00000000  68 65 6c 6c 6f 00                                |hello.|
# 00000006
```

```ruby
File.hexdump("/bin/ls")
# ...
```

### Output (file)

```ruby
File.open('dump.txt','w') do |file|
  data.hexdump(output: file)
end
```

### UTF-8

```ruby
Hexdump.hexdump("\u8000" * 8, encoding: :utf8)
# 00000000  e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8  |耀耀耀耀耀.|
# 00000010  80 80 e8 80 80 e8 80 80                          |..耀耀|
# 00000018
```

### Columns

```ruby
Hexdump.hexdump('A' * 30, columns: 10)
# 00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
# *
# 0000001e
```

### Repeating Columns

```ruby
Hexdump.hexdump('A' * 30, columns: 10, repeating: true)
# 00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
# 0000000a  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
# 00000014  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
# 0000001e
```

### Grouping Columns

```ruby
Hexdump.hexdump("ABCD" * 8, columns: 16, group_columns: 4, repeating: true)
# 00000000  41 42 43 44  41 42 43 44  41 42 43 44  41 42 43 44  |ABCDABCDABCDABCD|
# 00000010  41 42 43 44  41 42 43 44  41 42 43 44  41 42 43 44  |ABCDABCDABCDABCD|
# 00000020
```

### Grouping Chars

```ruby
Hexdump.hexdump("ABCD" * 8, group_chars: 4)
# 00000000  41 42 43 44 41 42 43 44 41 42 43 44 41 42 43 44  |ABCD|ABCD|ABCD|ABCD|
# *
# 00000020
```

### Grouping UTF-8 Chars

```ruby
Hexdump.hexdump("\u8000" * 8, group_chars: 4, encoding: :utf8)
# 00000000  e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8 80 80 e8  |耀.|...|.耀|耀.|
# 00000010  80 80 e8 80 80 e8 80 80                          |...|.耀|
# 00000018
```

### Disable Chars

```ruby
Hexdump.hexdump('A' * 30, chars_column: false)
00000000  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41
00000010  41 41 41 41 41 41 41 41 41 41 41 41 41 41      
0000001e
```

### Hexadecimal

```ruby
Hexdump.hexdump("hello\0", base: 16)
# 00000000  68 65 6c 6c 6f 00                                |hello.|
# 00000006
```

### Decimal

```ruby
Hexdump.hexdump("hello\0", base: 10)
# 00000000  104 101 108 108 111   0                                          |hello.|
# 00000006
```

### Octal

```ruby
Hexdump.hexdump("hello\0", base: 8)
# 00000000  0150 0145 0154 0154 0157 0000                                                    |hello.|
# 00000006
```

### Binary

```ruby
Hexdump.hexdump("hello\0", base: 2)
# 00000000  01101000 01100101 01101100 01101100 01101111 00000000                                                                                            |hello.|
# 00000006
```

### UInt Type

```ruby
Hexdump.hexdump("ABCD" * 7, type: :uint32)
# 00000000  44434241 44434241 44434241 44434241  |ABCDABCDABCDABCD|
# 00000010  44434241 44434241 44434241           |ABCDABCDABCD|
# 0000001c
```

### Little-endian

```ruby
Hexdump.hexdump("ABCD" * 7, type: :uint32_le)
# 00000000  44434241 44434241 44434241 44434241  |ABCDABCDABCDABCD|
# 00000010  44434241 44434241 44434241           |ABCDABCDABCD|
# 0000001c
```

### Big-endian

```ruby
Hexdump.hexdump("ABCD" * 7, type: :uint32_be)
# 00000000  41424344 41424344 41424344 41424344  |ABCDABCDABCDABCD|
# 00000010  41424344 41424344 41424344           |ABCDABCDABCD|
# 0000001c
```

### Int Type

```ruby
Hexdump.hexdump([65535, -1].pack("LL"), type: :int32_be, base: 10)
# 00000000       65535         -1                          |........|
# 00000008
```

### Char Type

```ruby
Hexdump.hexdump("hello\0", type: :char)
# 00000000    h   e   l   l   o  \0                                          |hello.|
# 00000006
```

### Float Type

```ruby
Hexdump.hexdump([0.0, 1.0, -1.0, Float::NAN].pack('EEEE'), type: :float64_le)
# 00000000          0.000000e+00         1.000000e+00  |...............?|
# 00000010         -1.000000e+00                  NaN  |................|
# 00000020
```

### Skipping Data

```ruby
Hexdump.hexdump("GARBAGEabc123", offset: 7)
# 00000007  61 62 63 31 32 33                                |abc123|
# 0000000d
```

### Zero-padding

```ruby
Hexdump.hexdump(("ABCD" * 4) + "AB", type: :uint32_be, zero_pad: true)
# 00000000  41424344 41424344 41424344 41424344  |ABCDABCDABCDABCD|
# 00000010  41420000                             |AB..|
# 00000014
```

### ANSI Styling

```ruby
Hexdump.hexdump("ABCD", style: {index: :white, numeric: :green, chars: :cyan})
```

### ANSI Highlighting

```ruby
Hexdump.hexdump((0..255).map(&:chr).join, highlights: {
  index: {/00$/ => [:white, :bold]},
  numeric: {
    /^[8-f][0-9a-f]$/ => :faint,
    /f/  => :cyan,
    '00' => [:black, :on_red]
  },
  chars: {/[^\.]+/ => :green}
})
```

### Block Configuration

```ruby
Hexdump.hexdump("hello\0") do |hex|
  hex.type = :uint16_le
  hex.group_chars = :type
  # ...
end
# 00000000  6568 6c6c 006f                           |he|ll|o.|
# 00000006
```

## Benchmarks

Benchmarks show hexdumping 1Mb of random data.

### Ruby 2.7.4

```
                                                 user     system      total        real
Hexdump.hexdump(data)                        1.148697   0.025829   1.174526 (  1.183447)
Hexdump.hexdump(data, repeating: false)      1.050473   0.000000   1.050473 (  1.057167)
Hexdump.hexdump(data, chars_column: false)   0.878459   0.002912   0.881371 (  0.888779)
Hexdump.hexdump(data, columns: 256)          0.793922   0.008785   0.802707 (  0.810535)
Hexdump.hexdump(data, group_columns: 4)      1.309818   0.000000   1.309818 (  1.320721)
Hexdump.hexdump(data, group_chars: 4)        1.949181   0.000000   1.949181 (  1.975533)
Hexdump.hexdump(data, encoding: :utf8)       1.292495   0.000000   1.292495 (  1.302071)
Hexdump.hexdump(data, type: :char)           1.168044   0.000000   1.168044 (  1.177700)
Hexdump.hexdump(data, type: :uchar)          1.033165   0.000000   1.033165 (  1.041185)
Hexdump.hexdump(data, type: :int8)           1.310548   0.000000   1.310548 (  1.319847)
Hexdump.hexdump(data, type: :uint8)          1.035534   0.000000   1.035534 (  1.041428)
Hexdump.hexdump(data, type: :int16)          1.351306   0.009906   1.361212 (  1.370048)
Hexdump.hexdump(data, type: :int16_le)       1.320781   0.002981   1.323762 (  1.331747)
Hexdump.hexdump(data, type: :int16_be)       1.401554   0.003986   1.405540 (  1.414568)
Hexdump.hexdump(data, type: :int16_ne)       1.367864   0.000000   1.367864 (  1.376459)
Hexdump.hexdump(data, type: :uint16)         1.425247   0.003965   1.429212 (  1.438618)
Hexdump.hexdump(data, type: :uint16_le)      1.399240   0.002979   1.402219 (  1.411098)
Hexdump.hexdump(data, type: :uint16_be)      1.409289   0.006960   1.416249 (  1.424767)
Hexdump.hexdump(data, type: :uint16_ne)      1.288829   0.000001   1.288830 (  1.296091)
Hexdump.hexdump(data, type: :int32)          1.089239   0.000000   1.089239 (  1.094715)
Hexdump.hexdump(data, type: :int32_le)       1.429353   0.000003   1.429356 (  1.441620)
Hexdump.hexdump(data, type: :int32_be)       1.472933   0.000000   1.472933 (  1.486328)
Hexdump.hexdump(data, type: :int32_ne)       1.357824   0.000000   1.357824 (  1.369258)
Hexdump.hexdump(data, type: :uint32)         1.214704   0.000000   1.214704 (  1.222920)
Hexdump.hexdump(data, type: :uint32_le)      1.253424   0.000000   1.253424 (  1.262441)
Hexdump.hexdump(data, type: :uint32_be)      1.325268   0.000000   1.325268 (  1.335447)
Hexdump.hexdump(data, type: :uint32_ne)      1.314893   0.000819   1.315712 (  1.328889)
Hexdump.hexdump(data, type: :int64)          1.083071   0.000000   1.083071 (  1.092108)
Hexdump.hexdump(data, type: :int64_le)       1.076378   0.000000   1.076378 (  1.084785)
Hexdump.hexdump(data, type: :int64_be)       0.998069   0.000000   0.998069 (  1.005166)
Hexdump.hexdump(data, type: :int64_ne)       0.990422   0.000000   0.990422 (  1.005638)
Hexdump.hexdump(data, type: :uint64)         1.010946   0.000000   1.010946 (  1.018339)
Hexdump.hexdump(data, type: :uint64_le)      0.961576   0.000000   0.961576 (  0.967806)
Hexdump.hexdump(data, type: :uint64_be)      0.979367   0.000000   0.979367 (  0.985515)
Hexdump.hexdump(data, type: :uint64_ne)      1.017737   0.000000   1.017737 (  1.024689)
Hexdump.hexdump(data, type: :float32)        1.237278   0.000000   1.237278 (  1.245206)
Hexdump.hexdump(data, type: :float32_le)     1.233321   0.000000   1.233321 (  1.241154)
Hexdump.hexdump(data, type: :float32_be)     1.245740   0.000000   1.245740 (  1.253952)
Hexdump.hexdump(data, type: :float32_ne)     1.256216   0.000000   1.256216 (  1.264893)
Hexdump.hexdump(data, type: :float64)        1.122882   0.000000   1.122882 (  1.130954)
Hexdump.hexdump(data, type: :float64_le)     1.117593   0.000000   1.117593 (  1.125222)
Hexdump.hexdump(data, type: :float64_be)     1.139602   0.000000   1.139602 (  1.147980)
Hexdump.hexdump(data, type: :float64_ne)     1.142568   0.000000   1.142568 (  1.150949)
```

### Ruby 3.0.2

```
                                                 user     system      total        real
Hexdump.hexdump(data)                        0.902383   0.046875   0.949258 (  0.953623)
Hexdump.hexdump(data, repeating: false)      0.892407   0.000046   0.892453 (  0.896401)
Hexdump.hexdump(data, chars_column: false)   0.705909   0.001029   0.706938 (  0.709924)
Hexdump.hexdump(data, columns: 256)          0.627444   0.009986   0.637430 (  0.640324)
Hexdump.hexdump(data, group_columns: 4)      1.081550   0.001041   1.082591 (  1.087987)
Hexdump.hexdump(data, group_chars: 4)        1.444519   0.000000   1.444519 (  1.452809)
Hexdump.hexdump(data, encoding: :utf8)       1.078177   0.000003   1.078180 (  1.082981)
Hexdump.hexdump(data, type: :char)           0.865217   0.000000   0.865217 (  0.868752)
Hexdump.hexdump(data, type: :uchar)          0.736559   0.000000   0.736559 (  0.739721)
Hexdump.hexdump(data, type: :int8)           1.042024   0.000000   1.042024 (  1.046687)
Hexdump.hexdump(data, type: :uint8)          0.917350   0.000005   0.917355 (  0.921428)
Hexdump.hexdump(data, type: :int16)          1.351638   0.004978   1.356616 (  1.363879)
Hexdump.hexdump(data, type: :int16_le)       1.315200   0.006944   1.322144 (  1.329052)
Hexdump.hexdump(data, type: :int16_be)       1.421759   0.005966   1.427725 (  1.435760)
Hexdump.hexdump(data, type: :int16_ne)       1.444364   0.001995   1.446359 (  1.454039)
Hexdump.hexdump(data, type: :uint16)         1.491169   0.001000   1.492169 (  1.500542)
Hexdump.hexdump(data, type: :uint16_le)      1.439111   0.000000   1.439111 (  1.447745)
Hexdump.hexdump(data, type: :uint16_be)      1.464961   0.000836   1.465797 (  1.473807)
Hexdump.hexdump(data, type: :uint16_ne)      1.407008   0.000808   1.407816 (  1.415236)
Hexdump.hexdump(data, type: :int32)          1.048519   0.000004   1.048523 (  1.053326)
Hexdump.hexdump(data, type: :int32_le)       1.080497   0.000000   1.080497 (  1.085598)
Hexdump.hexdump(data, type: :int32_be)       1.033985   0.000000   1.033985 (  1.038472)
Hexdump.hexdump(data, type: :int32_ne)       1.057491   0.000000   1.057491 (  1.062123)
Hexdump.hexdump(data, type: :uint32)         1.019488   0.000000   1.019488 (  1.023838)
Hexdump.hexdump(data, type: :uint32_le)      1.014077   0.000003   1.014080 (  1.018370)
Hexdump.hexdump(data, type: :uint32_be)      1.038020   0.000000   1.038020 (  1.042756)
Hexdump.hexdump(data, type: :uint32_ne)      1.047465   0.000000   1.047465 (  1.052377)
Hexdump.hexdump(data, type: :int64)          0.842281   0.000000   0.842281 (  0.845988)
Hexdump.hexdump(data, type: :int64_le)       0.840408   0.000000   0.840408 (  0.844103)
Hexdump.hexdump(data, type: :int64_be)       0.845470   0.000002   0.845472 (  0.849219)
Hexdump.hexdump(data, type: :int64_ne)       0.843975   0.000000   0.843975 (  0.847644)
Hexdump.hexdump(data, type: :uint64)         0.836761   0.000000   0.836761 (  0.840326)
Hexdump.hexdump(data, type: :uint64_le)      0.828863   0.000000   0.828863 (  0.832319)
Hexdump.hexdump(data, type: :uint64_be)      0.839492   0.000001   0.839493 (  0.843017)
Hexdump.hexdump(data, type: :uint64_ne)      0.843799   0.000000   0.843799 (  0.847764)
Hexdump.hexdump(data, type: :float32)        1.091306   0.000000   1.091306 (  1.096429)
Hexdump.hexdump(data, type: :float32_le)     1.077634   0.000000   1.077634 (  1.082633)
Hexdump.hexdump(data, type: :float32_be)     1.085840   0.000986   1.086826 (  1.092056)
Hexdump.hexdump(data, type: :float32_ne)     1.093757   0.000000   1.093757 (  1.099011)
Hexdump.hexdump(data, type: :float64)        0.873676   0.010942   0.884618 (  0.888978)
Hexdump.hexdump(data, type: :float64_le)     0.865006   0.003984   0.868990 (  0.873156)
Hexdump.hexdump(data, type: :float64_be)     0.879795   0.009947   0.889742 (  0.894389)
Hexdump.hexdump(data, type: :float64_ne)     0.876483   0.010934   0.887417 (  0.892222)
```

### JRuby 9.2.19.0

```
                                                 user     system      total        real
Hexdump.hexdump(data)                        6.440000   0.260000   6.700000 (  1.990004)
Hexdump.hexdump(data, repeating: false)      1.920000   0.010000   1.930000 (  0.973891)
Hexdump.hexdump(data, chars_column: false)   1.680000   0.010000   1.690000 (  0.848573)
Hexdump.hexdump(data, columns: 256)          0.920000   0.010000   0.930000 (  0.703203)
Hexdump.hexdump(data, group_columns: 4)      2.070000   0.010000   2.080000 (  1.119408)
Hexdump.hexdump(data, group_chars: 4)        2.200000   0.010000   2.210000 (  1.427454)
Hexdump.hexdump(data, encoding: :utf8)       2.280000   0.010000   2.290000 (  1.148070)
Hexdump.hexdump(data, type: :char)           1.970000   0.020000   1.990000 (  1.022860)
Hexdump.hexdump(data, type: :uchar)          0.940000   0.000000   0.940000 (  0.780674)
Hexdump.hexdump(data, type: :int8)           1.580000   0.000000   1.580000 (  1.086830)
Hexdump.hexdump(data, type: :uint8)          0.980000   0.010000   0.990000 (  0.937851)
Hexdump.hexdump(data, type: :int16)          2.730000   0.030000   2.760000 (  1.571684)
Hexdump.hexdump(data, type: :int16_le)       1.620000   0.000000   1.620000 (  1.354835)
Hexdump.hexdump(data, type: :int16_be)       1.700000   0.010000   1.710000 (  1.430056)
Hexdump.hexdump(data, type: :int16_ne)       1.640000   0.000000   1.640000 (  1.437230)
Hexdump.hexdump(data, type: :uint16)         2.190000   0.100000   2.290000 (  1.801601)
Hexdump.hexdump(data, type: :uint16_le)      1.770000   0.010000   1.780000 (  1.585609)
Hexdump.hexdump(data, type: :uint16_be)      1.720000   0.000000   1.720000 (  1.555715)
Hexdump.hexdump(data, type: :uint16_ne)      1.760000   0.010000   1.770000 (  1.540340)
Hexdump.hexdump(data, type: :int32)          1.430000   0.000000   1.430000 (  1.133868)
Hexdump.hexdump(data, type: :int32_le)       1.060000   0.000000   1.060000 (  1.031721)
Hexdump.hexdump(data, type: :int32_be)       1.130000   0.010000   1.140000 (  1.096841)
Hexdump.hexdump(data, type: :int32_ne)       1.080000   0.000000   1.080000 (  1.074743)
Hexdump.hexdump(data, type: :uint32)         1.560000   0.010000   1.570000 (  1.053369)
Hexdump.hexdump(data, type: :uint32_le)      1.070000   0.000000   1.070000 (  1.001372)
Hexdump.hexdump(data, type: :uint32_be)      1.460000   0.020000   1.480000 (  1.080869)
Hexdump.hexdump(data, type: :uint32_ne)      1.120000   0.010000   1.130000 (  0.876941)
Hexdump.hexdump(data, type: :int64)          1.510000   0.010000   1.520000 (  0.865030)
Hexdump.hexdump(data, type: :int64_le)       0.860000   0.000000   0.860000 (  0.770903)
Hexdump.hexdump(data, type: :int64_be)       0.820000   0.000000   0.820000 (  0.768356)
Hexdump.hexdump(data, type: :int64_ne)       0.760000   0.010000   0.770000 (  0.752532)
Hexdump.hexdump(data, type: :uint64)         2.430000   0.000000   2.430000 (  1.011133)
Hexdump.hexdump(data, type: :uint64_le)      0.850000   0.010000   0.860000 (  0.823235)
Hexdump.hexdump(data, type: :uint64_be)      0.870000   0.000000   0.870000 (  0.822799)
Hexdump.hexdump(data, type: :uint64_ne)      0.900000   0.000000   0.900000 (  0.829247)
Hexdump.hexdump(data, type: :float32)        3.700000   0.020000   3.720000 (  1.862630)
Hexdump.hexdump(data, type: :float32_le)     1.430000   0.010000   1.440000 (  1.372024)
Hexdump.hexdump(data, type: :float32_be)     1.360000   0.010000   1.370000 (  1.333000)
Hexdump.hexdump(data, type: :float32_ne)     1.390000   0.000000   1.390000 (  1.354031)
Hexdump.hexdump(data, type: :float64)        2.830000   0.030000   2.860000 (  1.705892)
Hexdump.hexdump(data, type: :float64_le)     1.370000   0.000000   1.370000 (  1.356680)
Hexdump.hexdump(data, type: :float64_be)     1.430000   0.010000   1.440000 (  1.392404)
Hexdump.hexdump(data, type: :float64_ne)     1.380000   0.000000   1.380000 (  1.363983)
```

### TruffleRuby 21.2.0.1

```
                                                 user     system      total        real
Hexdump.hexdump(data)                        7.456088   0.230339   7.686427 (  2.378998)
Hexdump.hexdump(data, repeating: false)      5.737137   0.150997   5.888134 (  1.781732)
Hexdump.hexdump(data, chars_column: false)   6.671704   0.064265   6.735969 (  2.054377)
Hexdump.hexdump(data, columns: 256)          4.711081   0.023574   4.734655 (  1.352932)
Hexdump.hexdump(data, group_columns: 4)      8.762291   0.133901   8.896192 (  2.711132)
Hexdump.hexdump(data, group_chars: 4)       13.382068   0.127633  13.509701 (  4.128705)
Hexdump.hexdump(data, encoding: :utf8)       8.591975   0.138969   8.730944 (  2.676283)
Hexdump.hexdump(data, type: :char)           6.455997   0.059446   6.515443 (  1.953656)
Hexdump.hexdump(data, type: :uchar)          6.201412   0.048587   6.249999 (  1.732655)
Hexdump.hexdump(data, type: :int8)           8.712725   0.095197   8.807922 (  2.587043)
Hexdump.hexdump(data, type: :uint8)          5.553536   0.074358   5.627894 (  1.786634)
Hexdump.hexdump(data, type: :int16)         11.300609   0.114115  11.414724 (  3.440795)
Hexdump.hexdump(data, type: :int16_le)       8.040891   0.060503   8.101394 (  2.388759)
Hexdump.hexdump(data, type: :int16_be)       6.602434   0.087225   6.689659 (  2.082091)
Hexdump.hexdump(data, type: :int16_ne)       5.448411   0.076425   5.524836 (  1.696039)
Hexdump.hexdump(data, type: :uint16)        10.081909   0.157579  10.239488 (  3.106461)
Hexdump.hexdump(data, type: :uint16_le)      6.847504   0.040543   6.888047 (  2.069546)
Hexdump.hexdump(data, type: :uint16_be)      6.730759   0.149299   6.880058 (  2.147346)
Hexdump.hexdump(data, type: :uint16_ne)      5.539179   0.108832   5.648011 (  1.747539)
Hexdump.hexdump(data, type: :int32)          7.998790   0.058401   8.057191 (  2.383304)
Hexdump.hexdump(data, type: :int32_le)       4.650657   0.081202   4.731859 (  1.412741)
Hexdump.hexdump(data, type: :int32_be)      11.538588   0.089259  11.627847 (  3.557763)
Hexdump.hexdump(data, type: :int32_ne)       9.605673   0.146677   9.752350 (  2.995870)
Hexdump.hexdump(data, type: :uint32)        10.404964   0.106136  10.511100 (  3.118580)
Hexdump.hexdump(data, type: :uint32_le)      4.851154   0.080325   4.931479 (  1.463532)
Hexdump.hexdump(data, type: :uint32_be)     11.293044   0.100121  11.393165 (  3.539708)
Hexdump.hexdump(data, type: :uint32_ne)      9.907893   0.122000  10.029893 (  3.165294)
Hexdump.hexdump(data, type: :int64)          9.103719   0.102995   9.206714 (  2.775106)
Hexdump.hexdump(data, type: :int64_le)       9.304751   0.180642   9.485393 (  2.922495)
Hexdump.hexdump(data, type: :int64_be)       7.166353   0.089344   7.255697 (  2.215438)
Hexdump.hexdump(data, type: :int64_ne)       6.874170   0.090186   6.964356 (  2.113975)
Hexdump.hexdump(data, type: :uint64)        12.997911   0.165758  13.163669 (  4.081488)
Hexdump.hexdump(data, type: :uint64_le)      8.949650   0.130855   9.080505 (  2.712645)
Hexdump.hexdump(data, type: :uint64_be)      8.948030   0.173500   9.121530 (  2.842953)
Hexdump.hexdump(data, type: :uint64_ne)      8.055399   0.153749   8.209148 (  2.547932)
Hexdump.hexdump(data, type: :float32)       14.345624   0.241224  14.586848 (  4.508393)
Hexdump.hexdump(data, type: :float32_le)    10.454524   0.103136  10.557660 (  3.112175)
Hexdump.hexdump(data, type: :float32_be)    11.073294   0.202252  11.275546 (  3.443881)
Hexdump.hexdump(data, type: :float32_ne)     9.990956   0.091216  10.082172 (  3.022276)
Hexdump.hexdump(data, type: :float64)       16.629231   0.279989  16.909220 (  5.163906)
Hexdump.hexdump(data, type: :float64_le)    13.761375   0.190385  13.951760 (  4.129403)
Hexdump.hexdump(data, type: :float64_be)    16.121047   0.277863  16.398910 (  5.019326)
Hexdump.hexdump(data, type: :float64_ne)     8.873162   0.068414   8.941576 (  4.748072)
```

## Copyright

Copyright (c) 2011-2021 Hal Brodigan

See {file:LICENSE.txt} for details.
