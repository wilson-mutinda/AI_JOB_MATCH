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

  describe "#user_search" do
    let(:users) do
      [
        OpenStruct.new(id: 1),
        OpenStruct.new(id: 2),
        OpenStruct.new(id: 6),
        OpenStruct.new(id: 4),
        OpenStruct.new(id: 3),
        OpenStruct.new(id: 5)
    ].sort_by(&:id)
    end

    it 'returns user object if target_id is equal to mid_user_id' do
      result = helper.binary_user_search(users, 3)
      expect(result).to eq(users[2])
    end
  end

  describe "#binary_email_search" do
    let(:users) do
      [
        OpenStruct.new(email: "aa@gmail.com"),
        OpenStruct.new(email: "bb@gmail.com"),
        OpenStruct.new(email: "ab@gmail.com"),
        OpenStruct.new(email: "ba@gmail.com"),
    ].sort_by(&:email)
    end
    it "returns  an error if email already exists!" do
      result = helper.binary_email_search(users, "aa@gmail.com", 2)
      expect(result).to eq({ errors: { email: "Email already exists!"}})
    end
  end

  describe "#binary_phone_search" do
    let(:users) do
      [
        OpenStruct.new(phone: "254791738417"),
        OpenStruct.new(phone: "254712211221"),
        OpenStruct.new(phone: "254798989898"),
        OpenStruct.new(phone: "254176767676")
    ].sort_by(&:phone)
    end
    it "returns an error if phone already exists!" do
      result = helper.binary_phone_search(users, "254791738417", 3)
      expect(result).to eq({ errors: { phone: "Phone already exists!"}})
    end
  end

end
