#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib',__FILE__))

require 'hexdump'
require 'benchmark'

DATA = ((0..255).map { |b| b.chr }.join) * (1024 * 100)
OUTPUT = Class.new { def <<(data); end }.new

Benchmark.bm(33) do |b|
  b.report('Hexdump.dump (output)') do
    Hexdump.dump(DATA, :output => OUTPUT)
  end

  b.report('Hexdump.dump width=256 (output)') do
    Hexdump.dump(DATA, :width => 256, :output => OUTPUT)
  end

  b.report('Hexdump.dump ascii=true (output)') do
    Hexdump.dump(DATA, :ascii => true, :output => OUTPUT)
  end

  [2, 4, 8].each do |word_size|
    b.report("Hexdump.dump word_size=#{word_size} (output)") do
      Hexdump.dump(DATA, :word_size => word_size, :output => OUTPUT)
    end
  end

  b.report('hexdump.dump (block)') do
    Hexdump.dump(DATA) { |index,hex,print| }
  end

  b.report('Hexdump.dump width=256 (block)') do
    Hexdump.dump(DATA, :width => 256) { |index,hex,print| }
  end

  b.report('Hexdump.dump ascii=true (block)') do
    Hexdump.dump(DATA, :ascii => true) { |index,hex,print| }
  end

  [2, 4, 8].each do |word_size|
    b.report("hexdump.dump word_size=#{word_size} (block)") do
      Hexdump.dump(DATA, :word_size => word_size) { |index,hex,print| }
    end
  end
end
