require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/:id" do
    it "ログイン済みのユーザーが詳細画面にアクセスできること" do
      sign_in user
      get user_path(user)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(user.email)
      expect(response.body).to include("学習記録")
    end
  end
end
