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
end
