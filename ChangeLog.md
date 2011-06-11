### 0.2.0 / 2011-06-11

* Added {Hexdump::Dumper}.
* Added support for hexdumping 1, 2, 4, 8 byte words.
* Added support for hexdumping Little and Big Endian words.
* Optimized the hexdump algorithm to not use Arrays, use a lookup table
  of printable characters and cache formatted numbers.
* Opted into [test.rubygems.org](http://test.rubygems.org/).

### 0.1.0 / 2011-03-05

* Initial release:
  * Can hexdump any Object supporting the `each_byte` method.
  * Can send the hexdump output to any Object supporting the `<<` method.
  * Can yield each line of hexdump, instead of printing the output.
  * Supports printing hexadecimal, decimal, octal and binary bytes.
  * Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
  * Fast-ish.

