require 'spec_helper'
require 'hexdump/theme/rule'

describe Hexdump::Theme::Rule do
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
        expect(subject.style).to            be_kind_of(Hexdump::Theme::ANSI)
        expect(subject.style.parameters).to eq(style)
      end
    end

    context "when given no highlights: keyword argument" do
      it "must initialize #highlight_strings to {}" do
        expect(subject.highlight_strings).to eq({})
      end

      it "must initialize #highlight_regexps to {}" do
        expect(subject.highlight_regexps).to eq({})
      end
    end

    context "when given the highlights: keyword argument" do
      let(:highlights) { {/[a-f]/ => :green, '00' => :red} }

      subject { described_class.new(highlights: highlights) }

      it "must populate #highlight_strings with the String keys" do
        expect(subject.highlight_strings['00']).to be_kind_of(Hexdump::Theme::ANSI)
        expect(subject.highlight_strings['00'].parameters).to eq(:red)
      end

      it "must populate #highlight_regexps with the Regexp keys" do
        expect(subject.highlight_regexps[/[a-f]/]).to be_kind_of(Hexdump::Theme::ANSI)
        expect(subject.highlight_regexps[/[a-f]/].parameters).to eq(:green)
      end
    end
  end

  describe "#highlights" do
    let(:highlights) { {/[a-f]/ => :green, '00' => :red} }

    subject { described_class.new(highlights: highlights) }

    it "must combine #highlight_strings and #highlight_regexps" do
      expect(subject.highlights).to eq(subject.highlight_strings.merge(subject.highlight_regexps))
    end
  end

  describe "#highlight" do
    context "when given a String pattern" do
      let(:pattern) { '00' }
      let(:style)   { :red }

      before { subject.highlight(pattern,style) }

      it "must populate #highlight_strings with the given String" do
        expect(subject.highlight_strings[pattern]).to be_kind_of(Hexdump::Theme::ANSI)
        expect(subject.highlight_strings[pattern].parameters).to eq(style)
      end
    end

    context "when given a Regexp pattern" do
      let(:pattern) { /[a-f]/ }
      let(:style)   { :green }

      before { subject.highlight(pattern,style) }

      it "must populate #highlight_regexps with the given Regexp" do
        expect(subject.highlight_regexps[pattern]).to be_kind_of(Hexdump::Theme::ANSI)
        expect(subject.highlight_regexps[pattern].parameters).to eq(style)
      end
    end

    context "when not given a String or Regexp" do
      let(:pattern) { Object.new }
      let(:style)   { :red }

      it do
        expect {
          subject.highlight(pattern,style)
        }.to raise_error(ArgumentError,"pattern must be a String or Regexp: #{pattern.inspect}")
      end
    end
  end

  describe "#apply" do
    let(:string) { "00f0" }

    let(:highlights) { {'00' => :faint, /[a-f]/ => :green} }

    let(:reset) { Hexdump::Theme::ANSI::RESET              }
    let(:red)   { Hexdump::Theme::ANSI::PARAMETERS[:red]   }
    let(:green) { Hexdump::Theme::ANSI::PARAMETERS[:green] }

    context "when there are #highlight_strings rules" do
      let(:highlights) { {"00" => :red} }

      subject { described_class.new(highlights: highlights) }

      context "and the whole string matches a #highlight_strings rule" do
        let(:string) { '00' }

        it "must highlight the whole string" do
          expect(subject.apply(string)).to eq("#{red}#{string}#{reset}")
        end
      end

      context "but the string does not match any of the rules" do
        let(:string) { 'ff' }

        it "must return the given String" do
          expect(subject.apply(string)).to eq(string)
        end
      end
    end

    context "when there are #highlight_regexps rules" do
      let(:highlights) { {/f/ => :green} }

      subject { described_class.new(highlights: highlights) }

      context "and the whole string matches a #highlight_strings rule" do
        let(:string) { '00f0' }

        it "must highlight the matching substrings within the string" do
          expect(subject.apply(string)).to eq("00#{green}f#{reset}0")
        end

        context "and #style is initialized" do
          subject do
            described_class.new(
              style:      :cyan,
              highlights: highlights
            )
          end

          it "must re-enable the default style after resetting the highlighting" do
            expect(subject.apply(string)).to include("#{green}f#{reset}#{subject.style}")
          end

          context "when the beginning of the string is not highlighted" do
            let(:string) { "0f" }

            it "must prepend the string with the default style" do
              expect(subject.apply(string)).to eq("#{subject.style}0#{green}f#{reset}")
            end
          end

          context "when the end of the string is not highlighted" do
            let(:string) { "f0" }

            it "must append ANSI reset to the end of the string" do
              expect(subject.apply(string)).to eq("#{green}f#{reset}#{subject.style}0#{reset}")
            end
          end
        end
      end

      context "but the string does not match any of the rules" do
        let(:string) { '0000' }

        it "must return the given String" do
          expect(subject.apply(string)).to eq(string)
        end
      end
    end

    context "when #style is initialized" do
      let(:style) { :cyan }

      subject { described_class.new(style: style) }

      it "must wrap the given string with the style's ANSI string and reset" do
        expect(subject.apply(string)).to eq("#{subject.style}#{string}#{reset}")
      end
    end

    context "when #style is not initialized" do
      let(:string) { 'ff' }

      it "must return the given String" do
        expect(subject.apply(string)).to eq(string)
      end
    end
  end
end
