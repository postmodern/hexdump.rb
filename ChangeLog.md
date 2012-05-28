### 0.2.2 / 2012-05-27

* Added {Hexdump::VERSION}.
* Rescue `RangeError`s in {Hexdump::Dumper#format_printable}.
* Fixed a typo in `benchmarks/hexdump.rb` (thanks ColMcp).
* Fixed a typo in Source URL, in the README (thanks Lawrence Woodman).
* Documented the `:endian` option for {Hexdump.dump}.
* Replaced ore-tasks with
  [rubygems-tasks](https://github.com/postmodern/rubygems-tasks#readme).

### 0.2.1 / 2011-06-11

* Fixed a major bug in {Hexdump::Dumper#dump}, where the line buffers
  were not being cleared.

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

