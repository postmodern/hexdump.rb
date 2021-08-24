require 'spec_helper'
require 'hexdump/chars'

describe Hexdump::Chars do
  describe "#initialize" do
    it "must default #encoding to nil" do
      expect(subject.encoding).to be(nil)
    end

    context "when given nil" do
      subject { described_class.new(nil) }

      it "must set #encoding to nil" do
        expect(subject.encoding).to be(nil)
      end
    end

    context "when given an Encoding object" do
      let(:encoding) { Encoding::UTF_8 }

      subject { described_class.new(encoding) }

      it "must set #encoding to the Encoding object" do
        expect(subject.encoding).to be(encoding)
      end
    end
  end

  describe "#%" do
    context "when the string only contains printable ASCII characters" do
      let(:string)   { "hello" }

      it "must return the string unchanged" do
        expect(subject % string).to eq(string)
      end
    end

    context "when the string contains unprintable ASCII characters" do
      let(:ascii) { (0..255).map(&:chr).join }

      it "must replace non-printable ASCII characters with a '.'" do
        expect(subject % ascii).to eq(ascii.gsub(/[^\x20-\x7e]/,'.'))
      end
    end

    context "#encoding is set" do
      let(:encoding) { Encoding::UTF_8 }
      let(:string)   { "hello"         }

      subject { described_class.new(encoding) }

      it "must convert the string to the #encoding" do
        expect((subject % string).encoding).to eq(encoding)
      end

      context "when the string contains an invalid byte-sequence" do
        let(:invalid_bytes) { "\x80\x81"           }
        let(:string)        { "A#{invalid_bytes}B" }

        it "must replace any invalid byte sequencnes with a '.'" do
          expect(subject % string).to eq("A..B")
        end
      end

      context "when the string contains unprintable characters" do
        let(:codepoint) { 888                     }
        let(:char)      { codepoint.chr(encoding) }
        let(:string)    { "A#{char}B"             }

        it "must replace unprintable characters with a '.'" do
          expect(subject % string).to eq("A.B")
        end
      end
    end
  end
end
