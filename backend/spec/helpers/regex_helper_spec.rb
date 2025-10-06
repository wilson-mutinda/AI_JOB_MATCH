require 'rails_helper'

RSpec.describe RegexHelper, type: :helper do
  describe "#email_format" do
    it "returnsnormalized email when valid" do
      result = helper.email_format(" TEST@Example.Com" )
      expect(result).to eq("test@example.com")
    end

    it "raises error when email is blank" do
      expect { helper.email_format("") }.to raise_error("Invalid Email Format!")
    end

    it "raises error when email is badly formatted" do
      expect { helper.email_format("bad-email.com") }.to raise_error("Invalid Email Format!")
    end

  end

  describe "#phone_format" do
    it "normalized phone when valid" do
      result = helper.phone_format(" 2541 00990099")
      expect(result).to eq("254100990099")
    end

    it "returns an error if phpne is invalid" do
      expect { helper.phone_format("254698989009") }.to raise_error("Invalid Phone Format!")
    end

    it "returns an error if phone is null" do
      expect { helper.phone_format("") }.to raise_error("Invalid Phone Format!")
    end

    it "converts 01 prefix to 2541" do
      result = helper.phone_format("0198989898")
      expect(result).to eq("254198989898")
    end

    it "converts 07 prefix to 2547" do
      old = helper.phone_format("0791738417")
      expect(old).to eq("254791738417")
    end

    it "returns an error on non-digits" do
      expect { helper.phone_format("0798i8u765") }.to raise_error("Invalid Phone Format!")
    end
  end
end
