require 'rails_helper'
require 'ostruct'

RSpec.describe SearchHelper, type: :helper do
  describe "#email_search" do
    let(:users) do
      [
        OpenStruct.new(email: "alice@example.com"),
        OpenStruct.new(email: "bob@example.com"),
        OpenStruct.new(email: "charles@example.com")
    ].sort_by(&:email)
    end

    it "raises an error if email already exists" do
      result = helper.email_search(users, "bob@example.com")
      expect(result).to eq({ errors: { email: "Email Already Exists!"}})
    end

    it "does not raise if email does not exist" do
      result = helper.email_search(users, "david@example.com")
      expect(result).to eq({ errors: { email: ''}})
    end
  end

  describe "#phone_search" do
    let(:users) do
      [
        OpenStruct.new(phone: "254791738418"),
        OpenStruct.new(phone: "254791738419"),
        OpenStruct.new(phone: "254789898989"),
        OpenStruct.new(phone: "254123232323")
    ].sort_by(&:phone)
    end

    it "raises an error if phone already exists" do
      result = helper.phone_search(users, "254791738418")
      expect(result).to eq({ errors: { phone: "Phone Already Exists!"}})
    end
  end
end
