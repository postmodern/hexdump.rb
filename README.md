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
* Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
* Fast-ish.

## Benchmarks

Benchmarks show {Hexdump.dump} processing 2.4M of data.

### Ruby 1.9.2-p180

                                    user     system      total        real
    hexdump (block)             7.740000   0.030000   7.770000 (  8.138029)
    hexdump                     9.590000   0.050000   9.640000 ( 10.178203)
    hexdump width=256 (block)   7.280000   0.020000   7.300000 (  7.534507)
    hexdump width=256           8.130000   0.030000   8.160000 (  8.342448)
    hexdump ascii=true (block)  7.740000   0.030000   7.770000 (  7.958550)
    hexdump ascii=true          9.550000   0.050000   9.600000 (  9.803758)

### Ruby 1.8.7-p334

                                    user     system      total        real
    hexdump (block)            10.520000   0.010000  10.530000 ( 10.692901)
    hexdump                    11.580000   0.010000  11.590000 ( 11.873978)
    hexdump width=256 (block)   9.960000   0.110000  10.070000 ( 11.592033)
    hexdump width=256          10.660000   0.010000  10.670000 ( 10.987417)
    hexdump ascii=true (block) 10.620000   0.010000  10.630000 ( 10.899925)
    hexdump ascii=true         11.590000   0.030000  11.620000 ( 12.765259)

### Jruby 1.5.6

                                    user     system      total        real
    hexdump (block)             6.690000   0.000000   6.690000 (  6.517000)
    hexdump                     8.234000   0.000000   8.234000 (  8.234000)
    hexdump width=256 (block)   4.488000   0.000000   4.488000 (  4.488000)
    hexdump width=256           5.462000   0.000000   5.462000 (  5.462000)
    hexdump ascii=true (block)  4.456000   0.000000   4.456000 (  4.456000)
    hexdump ascii=true          5.039000   0.000000   5.039000 (  5.039000)

### Rubinius 1.2.3

                                    user     system      total        real
    hexdump (block)            10.013478   0.018997  10.032475 ( 11.148450)
    hexdump                    13.153001   0.015997  13.168998 ( 13.740888)
    hexdump width=256 (block)   8.845656   0.008999   8.854655 (  9.022673)
    hexdump width=256           9.894496   0.008999   9.903495 ( 10.121070)
    hexdump ascii=true (block)  9.576544   0.021996   9.598540 (  9.810846)
    hexdump ascii=true         13.088011   0.015998  13.104009 ( 13.390532)

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
