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
      expect {
        helper.email_search(users, "bob@example.com")
    }.to raise_error("Email Already Exists!")
    end

    it "does not raise if email does not exist" do
      expect {
        helper.email_search(users, "david@example.com")
    }.not_to raise_error
    end
  end
end
