require 'rails_helper'

RSpec.describe "Exams", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/exams/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/exams/show"
      expect(response).to have_http_status(:success)
    end
  end

end
