require 'spec_helper'
require 'hexdump/mixin'

describe Hexdump::Mixin do
  describe "#hexdump" do
    let(:bytes)       { [104, 101, 108, 108, 111] }
    let(:hex_chars)   { ['68', '65', '6c', '6c', '6f'] }
    let(:print_chars) { %w[h e l l o] }

    subject do
      obj = Object.new.extend(Hexdump::Mixin)

      each_byte = expect(obj).to receive(:each_byte)
      bytes.each do |b|
        each_byte = each_byte.and_yield(b)
      end

      obj
    end

    let(:index_format) { "%.8x" }

    let(:output) { StringIO.new }
    let(:lines)  { output.string.lines }

    it "should hexdump the object by calling #each_byte" do
      subject.hexdump(output: output)

      expect(lines.length).to be(2)
      expect(lines[0]).to start_with(index_format % 0)
      expect(lines[0]).to include(hex_chars.join(' '))
      expect(lines[0]).to end_with("|#{print_chars.join}|#{$/}")
      expect(lines[1]).to start_with(index_format % bytes.length)
    end
  end
end
