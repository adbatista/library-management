require 'rails_helper'

RSpec.describe "Sessions", :aggregate_failures, type: :request do
  describe "POST /session" do
    let(:user) { create(:user) }

    it "creates a new session with valid credentials" do
      session_params = {
        email_address: user.email_address,
        password: "password"
      }

      post "/session", params: session_params

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("token")
    end

    it "returns error with invalid credentials" do
      session_params = {
        email_address: user.email_address,
        password: "wrongpassword"
      }

      post "/session", params: session_params

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include("error" => "Invalid email or password")
    end
  end

  describe "DELETE /session" do
    let(:user) { create(:user) }
    let(:token) { create(:session, user: user).token }

    it "terminates the session" do
      delete "/session", headers: { "Authorization" => "Bearer #{token}" }

      expect(response).to have_http_status(:no_content)
      expect(Session.find_by(token: token)).to be_nil
    end
  end
end
