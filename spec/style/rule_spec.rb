require 'spec_helper'
require 'hexdump/style/rule'

describe Hexdump::Style::Rule do
  describe "#initialize" do
    context "when no style is given" do
      subject { described_class.new }

      it "must set #style to nil" do
        expect(subject.style).to be(nil)
      end
    end

    context "when given a style" do
      let(:style) { :bold }

      subject { described_class.new(style: style) }

      it "must initialize #style based on the given style" do
        expect(subject.style).to            be_kind_of(Hexdump::Style::ANSI)
        expect(subject.style.parameters).to eq(style)
      end
    end

    context "when given no highlights: keyword argument" do
      it "must initialize #highlights to {}" do
        expect(subject.highlights).to eq({})
      end
    end

    context "when given the highlights: keyword argument" do
      let(:highlights) { {/[a-f]/ => :red, /[0-9]/ => :red} }

      subject { described_class.new(highlights: highlights) }

      it "must populate #highlights based on the given highlights" do
        expect(subject.highlights.keys).to eq(highlights.keys)
        expect(subject.highlights.values).to all(be_kind_of(Hexdump::Style::ANSI))
      end
    end
  end

  describe "#highlight" do
    let(:highlights) { {'00' => :faint} }

    subject { described_class.new(highlights: highlights) }

    let(:pattern) { /[a-f]/ }
    let(:style)   { [:green, :bold] }

    before do
      subject.highlight(pattern,style)
    end

    it "must add the pattern and style to #highlights" do
      expect(subject.highlights[pattern]).to be_kind_of(Hexdump::Style::ANSI)
      expect(subject.highlights[pattern].parameters).to eq(style)
    end
  end

  describe "#apply" do
    let(:string) { "00f0" }

    let(:highlights) { {'00' => :faint, /[a-f]/ => :green} }

    let(:reset)      { Hexdump::Style::ANSI::RESET }
    let(:ansi_faint) { Hexdump::Style::ANSI::PARAMETERS[:faint] }
    let(:ansi_green) { Hexdump::Style::ANSI::PARAMETERS[:green] }

    context "when there is a default style" do
      let(:style) { :bold }

      subject { described_class.new(style: style) }

      let(:ansi)  { subject.style.string }

      it "must wrap the given string with the style's ANSI string and reset" do
        expect(subject.apply(string)).to eq("#{ansi}#{string}#{reset}")
      end

      context "and there is additional highlighting rules" do
        subject do
          described_class.new(style: style, highlights: highlights)
        end

        it "must still wrap the given string with the style's ANSI string and reset" do
          expect(subject.apply(string)).to start_with("#{ansi}")
          expect(subject.apply(string)).to end_with("#{reset}")
        end

        it "must wrap the matched substrings with the ANSI string and reset" do
          expect(subject.apply(string)).to include("#{ansi_faint}00#{reset}")
          expect(subject.apply(string)).to include("#{ansi_green}f#{reset}")
        end
      end
    end

    context "when there is no default style" do
      context "and there is no highlighting rules" do
        it "must return the given string with no modifications" do
          expect(subject.apply(string)).to eq(string)
        end
      end

      context "and there is additional highlighting rules" do
        let(:highlights) { {'00' => :faint, /[a-f]/ => :green} }

        let(:ansi_faint) { Hexdump::Style::ANSI::PARAMETERS[:faint] }
        let(:ansi_green) { Hexdump::Style::ANSI::PARAMETERS[:green] }

        subject { described_class.new(highlights: highlights) }

        it "must wrap the matched substrings with the ANSI string and reset" do
          expect(subject.apply(string)).to include("#{ansi_faint}00#{reset}")
          expect(subject.apply(string)).to include("#{ansi_green}f#{reset}")
        end
      end
    end
  end
end
