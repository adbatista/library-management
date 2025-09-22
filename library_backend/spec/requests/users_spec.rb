require 'rails_helper'

RSpec.describe "Users", :aggregate_failures, type: :request do
  describe "POST /users" do
    let(:valid_attributes) do
      {
        name: "John Doe",
        email_address: "a@a.com",
        password: "password",
        password_confirmation: "password",
        user_type: "member"
      }
    end

    it "creates a new user with valid attributes" do
      post "/users", params: { user: valid_attributes }

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include(
        "name" => "John Doe",
        "email_address" => "a@a.com",
        "user_type" => "member"
      )
    end

    it "returns error with invalid attributes" do
      invalid_attributes = valid_attributes.merge(email_address: "invalid_email")
      post "/users", params: { user: invalid_attributes }

      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)).to include("email_address")
    end

    it "returns error when password confirmations is different" do
      invalid_attributes = valid_attributes.merge(password_confirmation: "different_password")
      post "/users", params: { user: invalid_attributes }

      expect(response).to have_http_status(:unprocessable_content)
      expect(JSON.parse(response.body)).to include("password_confirmation")
    end
  end
end
