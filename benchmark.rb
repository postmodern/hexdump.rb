#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib',__FILE__))

require 'hexdump'
require 'benchmark'

DATA = ((0..255).map { |b| b.chr }.join) * (1024 * 20)
OUTPUT = Class.new { def print(data); end }.new

TYPES = Hexdump::TYPES.values.uniq.map(&Hexdump::TYPES.method(:key))

Benchmark.bm(33) do |b|
  b.report('Hexdump.hexdump(data))') do
    Hexdump.hexdump(DATA, output:  OUTPUT)
  end

  b.report('Hexdump.hexdump(data, columns: 256)') do
    Hexdump.hexdump(DATA, columns: 256, output: OUTPUT)
  end

  TYPES.each do |type|
    b.report("Hexdump.hexdump(data, type: #{type.inspect})") do
      Hexdump.hexdump(DATA, type: type, output: OUTPUT)
    end
  end
end
