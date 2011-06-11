# hexdump

* [Homepage](http://github.com/postmoderm/hexdump)
* [Issues](http://github.com/postmoderm/hexdump/issues)
* [Documentation](http://rubydoc.info/gems/hexdump/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description

Simple and Fast hexdumping for Ruby.

## Features

* Can hexdump any Object supporting the `each_byte` method.
* Can send the hexdump output to any Object supporting the `<<` method.
* Can yield each line of hexdump, instead of printing the output.
* Supports printing ASCII, hexadecimal, decimal, octal and binary bytes.
* Supports hexdumping 1, 2, 4, 8 byte words.
* Supports hexdumping Little and Big Endian words.
* Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
* Fast-ish.

## Benchmarks

Benchmarks show {Hexdump.dump} processing 2.4M of data.

### Ruby 1.9.2-p180

                                     user     system      total        real
    hexdump (block)              3.010000   0.010000   3.020000 (  3.529396)
    hexdump                      5.430000   0.030000   5.460000 (  6.216174)
    hexdump width=256 (block)    3.010000   0.020000   3.030000 (  3.308961)
    hexdump width=256            4.700000   0.040000   4.740000 (  5.520189)
    hexdump ascii=true (block)   3.050000   0.010000   3.060000 (  3.501436)
    hexdump ascii=true           5.450000   0.040000   5.490000 (  6.352144)
    hexdump word_size=2 (block)  7.420000   0.050000   7.470000 (  9.174734)
    hexdump word_size=2          9.500000   0.070000   9.570000 ( 11.228204)
    hexdump word_size=4 (block)  4.110000   0.030000   4.140000 (  4.849785)
    hexdump word_size=4          5.380000   0.060000   5.440000 (  6.209022)
    hexdump word_size=8 (block)  3.350000   0.070000   3.420000 (  4.147304)
    hexdump word_size=8          4.430000   0.040000   4.470000 (  5.930758)

### Ruby 1.8.7-p334

                                     user     system      total        real
    hexdump (block)              8.470000   0.020000   8.490000 (  9.585524)
    hexdump                     11.080000   0.050000  11.130000 ( 12.542401)
    hexdump width=256 (block)    8.360000   0.030000   8.390000 (  9.431877)
    hexdump width=256           10.310000   0.050000  10.360000 ( 12.278973)
    hexdump ascii=true (block)   8.550000   0.030000   8.580000 ( 10.502437)
    hexdump ascii=true          11.140000   0.040000  11.180000 ( 12.752712)
    hexdump word_size=2 (block) 12.680000   0.060000  12.740000 ( 14.657269)
    hexdump word_size=2         13.560000   0.080000  13.640000 ( 16.368675)
    hexdump word_size=4 (block)  8.500000   0.040000   8.540000 (  9.687623)
    hexdump word_size=4          9.340000   0.040000   9.380000 ( 10.657158)
    hexdump word_size=8 (block)  7.520000   0.040000   7.560000 (  8.565246)
    hexdump word_size=8          8.240000   0.040000   8.280000 (  9.475693)

### JRuby 1.5.6

                                     user     system      total        real
    hexdump (block)              6.742000   0.000000   6.742000 (  6.495000)
    hexdump                      7.498000   0.000000   7.498000 (  7.498000)
    hexdump width=256 (block)    4.601000   0.000000   4.601000 (  4.601000)
    hexdump width=256            5.569000   0.000000   5.569000 (  5.569000)
    hexdump ascii=true (block)   5.198000   0.000000   5.198000 (  5.198000)
    hexdump ascii=true           5.799000   0.000000   5.799000 (  5.798000)
    hexdump word_size=2 (block)  8.440000   0.000000   8.440000 (  8.440000)
    hexdump word_size=2          8.698000   0.000000   8.698000 (  8.698000)
    hexdump word_size=4 (block)  5.603000   0.000000   5.603000 (  5.602000)
    hexdump word_size=4          5.999000   0.000000   5.999000 (  5.999000)
    hexdump word_size=8 (block)  7.975000   0.000000   7.975000 (  7.975000)
    hexdump word_size=8          5.255000   0.000000   5.255000 (  5.255000)

### Rubinius 1.2.4

                                     user     system      total        real
    hexdump (block)              5.064230   0.029996   5.094226 (  6.236865)
    hexdump                      7.401875   0.039993   7.441868 ( 10.154394)
    hexdump width=256 (block)    4.149369   0.054992   4.204361 (  6.518306)
    hexdump width=256            4.960246   0.089986   5.050232 (  8.647516)
    hexdump ascii=true (block)   4.458322   0.026996   4.485318 (  5.570982)
    hexdump ascii=true           6.961941   0.056992   7.018933 (  9.895088)
    hexdump word_size=2 (block)  8.856653   0.078988   8.935641 ( 11.226360)
    hexdump word_size=2         10.489405   0.083988  10.573393 ( 12.980509)
    hexdump word_size=4 (block)  4.848263   0.047992   4.896255 (  6.526478)
    hexdump word_size=4          6.649989   0.053992   6.703981 (  8.245247)
    hexdump word_size=8 (block)  5.638143   0.047993   5.686136 ( 12.530454)
    hexdump word_size=8          7.598844   0.066990   7.665834 ( 16.881667)

## Examples

    require 'hexdump'

    data = "hello\x00"

    Hexdump.dump(data)
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    
    data.hexdump
    # 00000000  68 65 6c 6c 6f 00                                |hello.|

    File.open('dump.txt','w') do |file|
      data.hexdump(:output => file)
    end

    # iterate over the hexdump lines
    data.hexdump do |index,hex,printable|
      index     # => 0
      hex       # => ["68", "65", "6c", "6c", "6f", "00"]
      printable # => ["h", "e", "l", "l", "o", "."]
    end

    # configure the width of the hexdump
    Hexdump.dump('A' * 30, :width => 10)
    # 00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 0000000a  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 00000014  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|

    Hexdump.dump(data, :ascii => true)
    # 00000000  h e l l o 00                                     |hello.|

    Hexdump.dump(data, :base => 16)
    # 00000000  68 65 6c 6c 6f 00                                |hello.|

    Hexdump.dump(data, :base => :decimal)
    # 00000000  104 101 108 108 111   0                                          |hello.|

    Hexdump.dump(data, :base => :octal)
    # 00000000  0150 0145 0154 0154 0157 0000                                                    |hello.|

    Hexdump.dump(data, :base => :binary)
    # 00000000  01101000 01100101 01101100 01101100 01101111 00000000                                                                                            |hello.|

## Install

    $ gem install hexdump

## Copyright

Copyright (c) 2011 Hal Brodigan

See {file:LICENSE.txt} for details.
