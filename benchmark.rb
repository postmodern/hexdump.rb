#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('../lib',__FILE__))

require 'hexdump'
require 'benchmark'

class NullOutput
  def print(data)
  end
end

size_mb = 10
puts "Generating #{size_mb}Mb of random data ..."
data = Array.new(size_mb * 1_000 * 1024) { rand(255).chr }.join
output = NullOutput.new

types = Hexdump::TYPES.values.uniq.map(&Hexdump::TYPES.method(:key))

Benchmark.bm(40) do |b|
  b.report('Hexdump.hexdump(data)') do
    Hexdump.hexdump(data, output:  output)
  end

  b.report('Hexdump.hexdump(data, columns: 256)') do
    Hexdump.hexdump(data, columns: 256, output: output)
  end

  types.each do |type|
    b.report("Hexdump.hexdump(data, type: #{type.inspect})") do
      Hexdump.hexdump(data, type: type, output: output)
    end
  end
end
