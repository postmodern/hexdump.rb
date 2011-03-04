require 'spec_helper'
require 'hexdump'

describe Hexdump do
  let(:bytes) { [104, 101, 108, 108, 111] }
  let(:hex) { ['68', '65', '6c', '6c', '6f'] }
  let(:print) { ['h', 'e', 'l', 'l', 'o'] }
  let(:data) { print.join }

  it "should append each line of the hexdump to the output" do
    lines = []
    subject.dump(data, :output => lines)

    lines.length.should == 1
    lines[0].should include(hex.join(' '))
  end

  it "should yield the parts of each hexdump line to the given block" do
    lines = []

    subject.dump(data) do |index,hex,print|
      lines << [index, hex, print]
    end

    lines.length.should == 1
    lines[0][0].should == 0
    lines[0][1].should == hex
    lines[0][2].should == print
  end
end
