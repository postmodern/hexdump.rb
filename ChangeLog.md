### 1.0.1 / 2024-01-23

* Switched to using `require_relative` to improve load-times.
* Correctly alias `:long`/`:ulong` to `:int32`/`:uint32`.
* Disable ANSI styling in {Hexdump#hexdump} if the output is not a TTY.
* Removed the old `hexdump/extensions` file in favor of `hexdump/core_ext`.

### 1.0.0 / 2021-08-31

* Added the ability to hexdump typed data. Available `type:`s are :
  * `:char` - signed 8bit ASCII character
  * `:uchar` - unsigned 8bit ASCII character
  * `:int8` - signed 8bit integer
  * `:uin8` / `:byte` - unsigned 8bit integer (default)
  * `:int16` / `:short` - signed 16bit integer
  * `:int16_le` / `:short_le` - signed 16bit integer (little endian)
  * `:int16_be` / `:short_be` - signed 16bit integer (big endian)
  * `:int16_ne` / `:short_ne` - signed 16bit integer (network endian)
  * `:uint16` / `:ushort` - unsigned 16bit integer
  * `:uint16_le` / `:ushort_le` - unsigned 16bit integer (little endian)
  * `:uint16_be` / `:ushort_be` - unsigned 16bit integer (big endian)
  * `:uint16_ne` / `:ushort_ne` - unsigned 16bit integer (network endian)
  * `:int32` / `:int` / `:long` - signed 32bit integer
  * `:int32_le` / `:int_le` / `:long_le` - signed 32bit integer (little endian)
  * `:int32_be` / `:int_be` / `:long_be` - signed 32bit integer (big endian)
  * `:int32_ne` / `:int_ne` / `:long_ne` - signed 32bit integer (network endian)
  * `:uint32` / `:uint` / `:ulong` - unsigned 32bit integer
  * `:uint32_le` / `:uint_le` / `:ulong_le` - unsigned 32bit integer (little endian)
  * `:uint32_be` / `:uint_be` / `:ulong_be` - unsigned 32bit integer (big endian)
  * `:uint32_ne` / `:uint_ne` / `:ulong_ne` - unsigned 32bit integer (network endian)
  * `:int64` / `:long_long` - signed 64bit integer
  * `:int64_le` / `:long_long_le` - signed 64bit integer (little endian)
  * `:int64_be` / `:long_long_be` - signed 64bit integer (big endian)
  * `:int64_ne` / `:long_long_ne` - signed 64bit integer (network endian)
  * `:uint64` / `:ulong_long` - unsigned 64bit integer
  * `:uint64_le` / `:ulong_long_le` - unsigned 64bit integer (little endian)
  * `:uint64_be` / `:ulong_long_be` - unsigned 64bit integer (big endian)
  * `:uint64_ne` / `ulong_long_ne` - unsigned 64bit integer (network endian)
  * `:float` - single precision 32bit floating-point number
  * `:float_le` - single precision 32bit floating-point number (little endian)
  * `:float_be` - single precision 32bit floating-point number (big endian)
  * `:float_ne` - single precision 32bit floating-point number (network endian)
  * `:double` - double precision 64bit floating-point number
  * `:double_le` - double precision 64bit floating-point number (little endian)
  * `:double_be` - double precision 64bit floating-point number (big endian)
  * `:double_ne` - double precision 64bit floating-point number (network endian)
* Added support for optionally skipping N bytes or reading at most N bytes of
  data (ex: `offset: 10` and `length: 100`).
* Added support for optional zero-padding of the data so it aligns with the type
  size (ex: `zero_pad: true`).
* Added support for displaying the index in a separate numeric base than the
  numeric columns (ex: `index_base: 10, base: 2`). Defaults to base 16.
* Added support for omitting repeating rows with a `*` (ex: `repeating: true` or
  `repeating: false` to disable).
* Added support for grouping columns together like GNU `hexdump -C` (ex:
  `group_columns: 4`).
* Added support for grouping characters together (ex: `group_chars: 4`).
* Added support for grouping characters together to align with the type's size
  (ex: `group_chars: :type`).
* Added support for displaying UTF-8 characters or other character encodings.
* Added support for disabling the characters column entirely
  (ex: `chars_column: false`).
* Added support for ANSI styling and highlighting (ex: `style: {...}` and
  `highlights: {...}`).
* Added {Hexdump::ModuleMethods} to provide a top-level
  {Hexdump::ModuleMethods#hexdump hexdump} method.
  * Include {Hexdump::ModuleMethods} into {Kernel} by default.
* Added preliminary truffleruby support.
  * Only issue was https://github.com/oracle/truffleruby/issues/2426
* `hexdump` methods now accept a block for configuring the hexdump instance.
* Renamed `Hexdump::Dumper` to {Hexdump::Hexdump}.
* Renamed the `:width` option to `:columns`.

### 0.3.0 / 2021-04-10

* Require Ruby >= 2.0.0.
* Added support for Ruby 3.0.
* {Hexdump.dump}, {Hexdump#dump}, and `Hexdump::Dumper#initialize` now accept
  keyword arguments.
* `Hexdump::Dumper#each` now returns the total number of bytes read.
* `Hexdump::Dumper#dump` now prints the final number of bytes read on the last
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

* Added `Hexdump::Dumper`.
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

