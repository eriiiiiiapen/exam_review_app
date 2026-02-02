require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/subjects/show"
      expect(response).to have_http_status(:success)
    end
  end

end
