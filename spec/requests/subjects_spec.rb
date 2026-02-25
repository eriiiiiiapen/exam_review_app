require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/subjects/show"
      follow_redirect! while response.status.in?([302, 303])
      expect(response).to have_http_status(:success)
    end
  end

end
