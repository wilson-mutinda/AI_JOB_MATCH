require 'rails_helper'

RSpec.describe RegexHelper, type: :helper do
  describe "#email_format" do
    it "returnsnormalized email when valid" do
      result = helper.email_format(" TEST@Example.Com" )
      expect(result).to eq("test@example.com")
    end

    it "raises error when email is blank" do
      result = helper.email_format("")
      expect(result).to eq({ errors: { email: "Invalid Email Format!"}})
    end

    it "raises error when email is badly formatted" do
      result = helper.email_format("bad-email.com")
      expect(result).to eq({ errors: { email: "Invalid Email Format!"}})
    end

  end

  describe "#phone_format" do
    it "normalized phone when valid" do
      result = helper.phone_format(" 2541 00990099")
      expect(result).to eq("254100990099")
    end

    it "returns an error if phone is invalid" do
      result = helper.phone_format("2546989898")
      expect(result).to eq({ errors: { phone: "Invalid Phone Format!"}})
    end

    it "returns an error if phone is null" do
      result = helper.phone_format("")
      expect(result).to eq({ errors: { phone: "Invalid Phone Format!"}})
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
      result = helper.phone_format("0798i8u765")
      expect(result).to eq({ errors: { phone: "Invalid Phone Format!"}})
    end
  end

  describe "#password_regex" do
    it "returns an error if either password or password confirmation is missing" do
      result = helper.password_regex("user1234", "")
      expect(result).to eq({ errors: { password: "Password is required!", password_confirmation: "Password confirmation is required"}})
    end
  end
end
