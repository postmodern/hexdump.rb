require 'spec_helper'
require 'hexdump'

describe Hexdump do
  describe ".print" do
    let(:bytes)       { [104, 101, 108, 108, 111] }
    let(:hex_chars)   { ['68', '65', '6c', '6c', '6f'] }
    let(:print_chars) { %w[h e l l o] }
    let(:data)        { print_chars.join }

    let(:index_format) { "%.8x" }

    let(:output) { StringIO.new }
    let(:lines)  { output.string.lines }

    it "should print the hexdump of the given data" do
      subject.print(data, output: output)

      expect(lines.length).to be(2)
      expect(lines[0]).to start_with(index_format % 0)
      expect(lines[0]).to include(hex_chars.join(' '))
      expect(lines[0]).to end_with("|#{print_chars.join}|#{$/}")
      expect(lines[1]).to start_with(index_format % bytes.length)
    end
  end
end
