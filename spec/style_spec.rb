require 'spec_helper'
require 'hexdump/style'

describe Hexdump::Style do
  describe "#initialize" do
    it "must initialize #index" do
      expect(subject.index).to be_kind_of(Hexdump::Style::Rule)
    end

    it "must initialize #numeric" do
      expect(subject.numeric).to be_kind_of(Hexdump::Style::Rule)
    end

    it "must initialize #chars" do
      expect(subject.chars).to be_kind_of(Hexdump::Style::Rule)
    end

    context "when given a style Hash" do
      let(:index_style)   { :white }
      let(:numeric_style) { :cyan  }
      let(:chars_style)   { :blue  }

      subject do
        described_class.new(
          style: {
            index:   index_style,
            numeric: numeric_style,
            chars:   chars_style
          }
        )
      end

      it "must initialize #index" do
        expect(subject.index).to be_kind_of(Hexdump::Style::Rule)
      end

      it "must initialize #index.style" do
        expect(subject.index.style.parameters).to eq(index_style)
      end

      it "must initialize #numeric" do
        expect(subject.numeric).to be_kind_of(Hexdump::Style::Rule)
      end

      it "must initialize #numeric.style" do
        expect(subject.numeric.style.parameters).to eq(numeric_style)
      end

      it "must initialize #chars" do
        expect(subject.chars).to be_kind_of(Hexdump::Style::Rule)
      end

      it "must initialize #chars.style" do
        expect(subject.chars.style.parameters).to eq(chars_style)
      end
    end

    context "when given a highlight Hash" do
      let(:index_pattern)      { /00$/ }
      let(:index_highlight)    { :white }
      let(:index_highlights)   { {index_pattern => index_highlight} }

      let(:numeric_pattern)    { '00'    }
      let(:numeric_highlight)  { :faint  }
      let(:numeric_highlights) { {numeric_pattern => numeric_highlight}  }

      let(:chars_pattern)    { /A-Z/  }
      let(:chars_highlight)  { :bold  }
      let(:chars_highlights) { {chars_pattern => chars_highlight}  }

      subject do
        described_class.new(
          highlights: {
            index:   index_highlights,
            numeric: numeric_highlights,
            chars:   chars_highlights
          }
        )
      end

      it "must initialize #index.highlights" do
        expect(subject.index.highlights[index_pattern].parameters).to eq(index_highlight)
      end

      it "must initialize #numeric.highlights" do
        expect(subject.numeric.highlights[numeric_pattern].parameters).to eq(numeric_highlight)
      end

      it "must initialize #chars.highlights" do
        expect(subject.chars.highlights[chars_pattern].parameters).to eq(chars_highlight)
      end
    end
  end
end
