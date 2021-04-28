#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib',__FILE__))

require 'hexdump'
require 'benchmark'

DATA = ((0..255).map { |b| b.chr }.join) * (1024 * 20)
OUTPUT = Class.new { def <<(data); end }.new

TYPES = Hexdump::TYPES.values.uniq.map(&Hexdump::TYPES.method(:key))

Benchmark.bm(33) do |b|
  b.report('Hexdump.dump (output)') do
    Hexdump.dump(DATA, output:  OUTPUT)
  end

  b.report('Hexdump.dump columns: 256 (output)') do
    Hexdump.dump(DATA, columns: 256, output: OUTPUT)
  end

  TYPES.each do |type|
    b.report("Hexdump.dump type: #{type} (output)") do
      Hexdump.dump(DATA, type: type, output: OUTPUT)
    end
  end

  b.report('Hexdump.dump (block)') do
    Hexdump.dump(DATA) { |index,hex,print| }
  end

  b.report('Hexdump.dump columns: 256 (block)') do
    Hexdump.dump(DATA, columns: 256) { |index,hex,print| }
  end

  TYPES.each do |type|
    b.report("Hexdump.dump type: #{type} (block)") do
      Hexdump.dump(DATA, type: type) { |index,hex,print| }
    end
  end
end
