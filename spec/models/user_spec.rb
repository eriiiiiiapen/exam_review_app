require 'rails_helper'

RSpec.describe User, type: :model do
  it "メールがない場合は無効であること" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "重複したemailは登録できないこと" do
    create(:user, email: "overlap@example.com")
    user = build(:user, email: "overlap@example.com")
    expect(user).not_to be_valid
  end

  it "パスワードがない場合は無効であること" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end
end
