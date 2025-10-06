require 'rails_helper'

RSpec.describe SortHelper, type: :helper do
  describe "#sort_user_email;" do
    let(:users) do
      [
        OpenStruct.new(email: "gg@example.com"),
        OpenStruct.new(email: "cc@example.com"),
        OpenStruct.new(email: "dd@example.com"),
        OpenStruct.new(email: "aa@gmail.com"),
        OpenStruct.new(email: "az@gmail.com"),
    ].sort_by(&:email)
    end

    it "returns the array in an ascending order" do
      request = helper.sort_user_email(users)
      expect(request.map(&:email)).to eq(
        ["aa@gmail.com", "az@gmail.com", "cc@example.com", "dd@example.com", "gg@example.com"]
      )
    end
  end
end
