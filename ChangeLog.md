### 0.1.0 / 2011-03-05

* Initial release:
  * Can hexdump any Object supporting the `each_byte` method.
  * Can send the hexdump output to any Object supporting the `<<` method.
  * Can yield each line of hexdump, instead of printing the output.
  * Supports printing hexadecimal, decimal, octal and binary bytes.
  * Makes {String}, {StringIO}, {IO}, {File} objects hexdumpable.
  * Fast-ish.

