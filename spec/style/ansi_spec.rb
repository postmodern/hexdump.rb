require 'spec_helper'
require 'hexdump/style/ansi'

describe Hexdump::Style::ANSI do
  describe "RESET" do
    subject { described_class::RESET }

    it "must equal '\\e[0m'" do
      expect(subject).to eq("\e[0m")
    end
  end

  describe "PARAMETERS" do
    subject { described_class::PARAMETERS }

    describe ":bold" do
      subject { super()[:bold] }

      it "must equal '\\e[1m'" do
        expect(subject).to eq("\e[1m")
      end
    end

    describe ":faint" do
      subject { super()[:faint] }

      it "must equal '\\e[2m'" do
        expect(subject).to eq("\e[2m")
      end
    end

    describe ":italic" do
      subject { super()[:italic] }

      it "must equal '\\e[3m'" do
        expect(subject).to eq("\e[3m")
      end
    end

    describe ":underline" do
      subject { super()[:underline] }

      it "must equal '\\e[4m'" do
        expect(subject).to eq("\e[4m")
      end
    end

    describe ":invert" do
      subject { super()[:invert] }

      it "must equal '\\e[7m'" do
        expect(subject).to eq("\e[7m")
      end
    end

    describe ":strike" do
      subject { super()[:strike] }

      it "must equal '\\e[9m'" do
        expect(subject).to eq("\e[9m")
      end
    end

    describe ":black" do
      subject { super()[:black] }

      it "must equal '\\e[30m'" do
        expect(subject).to eq("\e[30m")
      end
    end

    describe ":red" do
      subject { super()[:red] }

      it "must equal '\\e[31m'" do
        expect(subject).to eq("\e[31m")
      end
    end

    describe ":green" do
      subject { super()[:green] }

      it "must equal '\\e[32m'" do
        expect(subject).to eq("\e[32m")
      end
    end

    describe ":yellow" do
      subject { super()[:yellow] }

      it "must equal '\\e[33m'" do
        expect(subject).to eq("\e[33m")
      end
    end

    describe ":blue" do
      subject { super()[:blue] }

      it "must equal '\\e[34m'" do
        expect(subject).to eq("\e[34m")
      end
    end

    describe ":magenta" do
      subject { super()[:magenta] }

      it "must equal '\\e[35m'" do
        expect(subject).to eq("\e[35m")
      end
    end

    describe ":cyan" do
      subject { super()[:cyan] }

      it "must equal '\\e[36m'" do
        expect(subject).to eq("\e[36m")
      end
    end

    describe ":white" do
      subject { super()[:white] }

      it "must equal '\\e[37m'" do
        expect(subject).to eq("\e[37m")
      end
    end

    describe ":on_black" do
      subject { super()[:on_black] }

      it "must equal '\\e[40m'" do
        expect(subject).to eq("\e[40m")
      end
    end

    describe ":on_red" do
      subject { super()[:on_red] }

      it "must equal '\\e[41m'" do
        expect(subject).to eq("\e[41m")
      end
    end

    describe ":on_green" do
      subject { super()[:on_green] }

      it "must equal '\\e[42m'" do
        expect(subject).to eq("\e[42m")
      end
    end

    describe ":on_yellow" do
      subject { super()[:on_yellow] }

      it "must equal '\\e[43m'" do
        expect(subject).to eq("\e[43m")
      end
    end

    describe ":on_blue" do
      subject { super()[:on_blue] }

      it "must equal '\\e[44m'" do
        expect(subject).to eq("\e[44m")
      end
    end

    describe ":on_magenta" do
      subject { super()[:on_magenta] }

      it "must equal '\\e[45m'" do
        expect(subject).to eq("\e[45m")
      end
    end

    describe ":on_cyan" do
      subject { super()[:on_cyan] }

      it "must equal '\\e[46m'" do
        expect(subject).to eq("\e[46m")
      end
    end

    describe ":on_white" do
      subject { super()[:on_white] }

      it "must equal '\\e[47m'" do
        expect(subject).to eq("\e[47m")
      end
    end
  end

  describe "#initialize" do
    context "when given one parameters name" do
      let(:parameters) { :bold }

      subject { described_class.new(parameters) }

      it "must set #parameters to that parameters name" do
        expect(subject.parameters).to eq(parameters)
      end

      it "must set #ansi to that parameters's ANSI string" do
        expect(subject.string).to eq(described_class::PARAMETERS[:bold])
      end
    end

    context "when given multiple parameters names" do
      let(:parameters) { [:bold, :green] }

      subject { described_class.new(parameters) }

      it "must set #parameters to that parameters names" do
        expect(subject.parameters).to eq(parameters)
      end

      it "must set #ansi to the combined parameters's ANSI strings" do
        expect(subject.string).to eq(
          described_class::PARAMETERS[:bold] + described_class::PARAMETERS[:green]
        )
      end
    end

    context "when given an unknown parameters name" do
      let(:parameter) { :foo }

      it do
        expect {
          described_class.new(parameter)
        }.to raise_error(ArgumentError,"unknown ANSI parameter: #{parameter}")
      end
    end
  end
end
