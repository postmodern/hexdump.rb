### 0.3.0 / 2021-04-10

* Require Ruby >= 2.0.0.
* Added support for Ruby 3.0.
* {Hexdump.dump}, {Hexdump#dump}, and {Hexdump::Dumper#initialize} now accept
  keyword arguments.
* {Hexdump::Dumper#each} now returns the total number of bytes read.
* {Hexdump::Dumper#dump} now prints the final number of bytes read on the last
  line.
* Micro-optimizations to improve performance on JRuby and TruffleRuby.

### 0.2.4 / 2020-09-26

* Default the `:output` option of {Hexdump.dump} to `$stdout` instead of
  `STDOUT`, to support overriding the default stdout stream (@kylekyle).

### 0.2.3 / 2012-05-28

* Fixed a typo in the gemspec, which incorrectly set
  `required_rubygems_version` to the same value as `required_ruby_version`.

### 0.2.2 / 2012-05-27

* Added {Hexdump::VERSION}.
* Rescue `RangeError`s in `Hexdump::Dumper#format_printable`.
* Fixed a typo in `benchmarks/hexdump.rb` (thanks ColMcp).
* Fixed a typo in Source URL, in the README (thanks Lawrence Woodman).
* Documented the `:endian` option for {Hexdump.dump}.
* Replaced ore-tasks with
  [rubygems-tasks](https://github.com/postmodern/rubygems-tasks#readme).

### 0.2.1 / 2011-06-11

* Fixed a major bug in `Hexdump::Dumper#dump`, where the line buffers
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

