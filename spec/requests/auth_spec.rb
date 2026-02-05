require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }

  it "ログインしログアウトができること" do
    sign_in user
    get user_root_path
    
    # 302: Devise標準
    # 303: Turbo用
    follow_redirect! while response.status.in?([302, 303])
    
    expect(response).to have_http_status(:success)
    expect(response.body).to include("ログアウト")

    delete destroy_user_session_path

    follow_redirect! while response.status.in?([302, 303])

    expect(response).to have_http_status(:success)
    expect(response.body).to include("ログイン")
    expect(response.body).not_to include("ログアウト")
  end
end