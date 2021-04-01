# hexdump

[![CI](https://github.com/postmodern/hexdump/actions/workflows/ruby.yml/badge.svg)](https://github.com/postmodern/hexdump/actions/workflows/ruby.yml)

* [Source](https://github.com/postmodern/hexdump)
* [Issues](https://github.com/postmodern/hexdump/issues)
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

## Examples

    require 'hexdump'

    data = "hello\x00"

    Hexdump.dump(data)
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006
    
    data.hexdump
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006

    File.open('dump.txt','w') do |file|
      data.hexdump(:output => file)
    end

    # iterate over the hexdump lines
    data.hexdump do |index,hex,printable|
      index     # => 0
      hex       # => ["68", "65", "6c", "6c", "6f", "00"]
      printable # => ["h", "e", "l", "l", "o", "."]
    end
    # => 6

    # configure the width of the hexdump
    Hexdump.dump('A' * 30, width: 10)
    # 00000000  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 0000000a  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 00000014  41 41 41 41 41 41 41 41 41 41  |AAAAAAAAAA|
    # 0000001e

    Hexdump.dump(data, ascii: true)
    # 00000000  h e l l o 00                                     |hello.|
    # 00000006

    Hexdump.dump(data, base: 16)
    # 00000000  68 65 6c 6c 6f 00                                |hello.|
    # 00000006

    Hexdump.dump(data, base: :decimal)
    # 00000000  104 101 108 108 111   0                                          |hello.|
    # 00000006

    Hexdump.dump(data, base: :octal)
    # 00000000  0150 0145 0154 0154 0157 0000                                                    |hello.|
    # 00000006

    Hexdump.dump(data, base: :binary)
    # 00000000  01101000 01100101 01101100 01101100 01101111 00000000                                                                                            |hello.|
    # 00000006

    ("ABC" * 10).hexdump(word_size: 2)
    # 00000000  4241 4143 4342 4241 4143 4342 4241 4143  |䉁䅃䍂䉁䅃䍂䉁䅃|
    # 00000010  4342 4241 4143 4342 4241 4143 4342       |䍂䉁䅃䍂䉁䅃䍂|
    # 0000001e

## Install

    $ gem install hexdump

## Benchmarks

Benchmarks show {Hexdump.dump} processing 25M of data.

### Ruby 2.7.2

```
                                        user     system      total        real
Hexdump.dump (output)              12.479208   0.000000  12.479208 ( 12.535753)
Hexdump.dump width=256 (output)    10.560755   0.001586  10.562341 ( 10.597715)
Hexdump.dump ascii=true (output)   12.488982   0.000000  12.488982 ( 12.530661)
Hexdump.dump word_size=2 (output)  16.395263   0.000000  16.395263 ( 16.453508)
Hexdump.dump word_size=4 (output)  14.448080   0.000000  14.448080 ( 14.506035)
Hexdump.dump word_size=8 (output)   7.740886   0.000000   7.740886 (  7.768686)
Hexdump.dump (block)                7.621674   0.000000   7.621674 (  7.643375)
Hexdump.dump width=256 (block)      7.471325   0.000000   7.471325 (  7.492967)
Hexdump.dump ascii=true (block)     7.975231   0.000000   7.975231 (  7.997686)
Hexdump.dump word_size=2 (block)   12.754562   0.000000  12.754562 ( 12.796870)
Hexdump.dump word_size=4 (block)   11.619628   0.000000  11.619628 ( 11.665158)
Hexdump.dump word_size=8 (block)    5.597346   0.000000   5.597346 (  5.614565)
```

### Ruby 3.0.0

```
                                        user     system      total        real
Hexdump.dump (output)              13.859625   0.003076  13.862701 ( 13.916746)
Hexdump.dump width=256 (output)    11.816353   0.002988  11.819341 ( 11.862517)
Hexdump.dump ascii=true (output)   14.092920   0.000001  14.092921 ( 14.149172)
Hexdump.dump word_size=2 (output)  18.421881   0.000001  18.421882 ( 18.503792)
Hexdump.dump word_size=4 (output)  16.391246   0.000984  16.392230 ( 16.475601)
Hexdump.dump word_size=8 (output)   8.769568   0.000000   8.769568 (  8.807117)
Hexdump.dump (block)                8.293908   0.000984   8.294892 (  8.324818)
Hexdump.dump width=256 (block)      8.010724   0.000989   8.011713 (  8.038550)
Hexdump.dump ascii=true (block)     8.328595   0.000000   8.328595 (  8.355812)
Hexdump.dump word_size=2 (block)   14.000797   0.000000  14.000797 ( 14.059903)
Hexdump.dump word_size=4 (block)   12.985078   0.000000  12.985078 ( 13.048142)
Hexdump.dump word_size=8 (block)    6.201691   0.000000   6.201691 (  6.225947)
```

### JRuby 9.2.16.0

```
                                        user     system      total        real
Hexdump.dump (output)              13.050000   0.550000  13.600000 ( 11.532856)
Hexdump.dump width=256 (output)     9.580000   0.040000   9.620000 (  9.388971)
Hexdump.dump ascii=true (output)   10.990000   0.080000  11.070000 ( 10.767254)
Hexdump.dump word_size=2 (output)  63.590000   0.310000  63.900000 ( 61.609994)
Hexdump.dump word_size=4 (output) 401.740000   1.340000 403.080000 (399.056659)
Hexdump.dump word_size=8 (output)   8.790000   0.050000   8.840000 (  7.684096)
Hexdump.dump (block)                8.240000   0.030000   8.270000 (  7.864539)
Hexdump.dump width=256 (block)      7.300000   0.000000   7.300000 (  7.243460)
Hexdump.dump ascii=true (block)     7.440000   0.010000   7.450000 (  7.309186)
Hexdump.dump word_size=2 (block)   55.710000   0.170000  55.880000 ( 55.377441)
Hexdump.dump word_size=4 (block)  378.980000   1.410000 380.390000 (376.949602)
Hexdump.dump word_size=8 (block)    6.450000   0.040000   6.490000 (  6.281612)
```

### TruffleRuby 21.0.0

```
                                        user     system      total        real
Hexdump.dump (output)              31.793750   0.606624  32.400374 ( 27.311739)
Hexdump.dump width=256 (output)    25.106739   0.322180  25.428919 ( 22.541041)
Hexdump.dump ascii=true (output)   29.138682   0.113125  29.251807 ( 24.774589)
Hexdump.dump word_size=2 (output) 157.728393   0.231903 157.960296 (153.989984)
Hexdump.dump word_size=4 (output) 1026.510944   0.293851 1026.804795 (1030.159870)
Hexdump.dump word_size=8 (output)  20.441870   0.130094  20.571964 ( 14.602901)
Hexdump.dump (block)                8.758839   0.070546   8.829385 (  6.518928)
Hexdump.dump width=256 (block)      6.861031   0.117127   6.978158 (  6.155890)
Hexdump.dump ascii=true (block)     7.690761   0.042608   7.733369 (  5.915393)
Hexdump.dump word_size=2 (block)  137.653294   0.584158 138.237452 (138.217996)
Hexdump.dump word_size=4 (block)  1000.214383   0.622550 1000.836933 (1005.895751)
Hexdump.dump word_size=8 (block)    9.866725   0.011896   9.878621 (  8.655384)
```

## Copyright

Copyright (c) 2011-2021 Hal Brodigan

See {file:LICENSE.txt} for details.
