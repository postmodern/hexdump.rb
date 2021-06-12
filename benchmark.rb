#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib',__FILE__))

require 'hexdump'
require 'benchmark'

DATA = ((0..255).map { |b| b.chr }.join) * (1024 * 20)
OUTPUT = Class.new { def print(data); end }.new

TYPES = Hexdump::TYPES.values.uniq.map(&Hexdump::TYPES.method(:key))

Benchmark.bm(33) do |b|
  b.report('Hexdump.print(output)') do
    Hexdump.print(DATA, output:  OUTPUT)
  end

  b.report('Hexdump.print columns: 256 (output)') do
    Hexdump.print(DATA, columns: 256, output: OUTPUT)
  end

  TYPES.each do |type|
    b.report("Hexdump.print type: #{type} (output)") do
      Hexdump.print(DATA, type: type, output: OUTPUT)
    end
  end
end
