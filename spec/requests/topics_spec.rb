require 'rails_helper'

RSpec.describe "Topics", type: :request do
  let(:user) { create(:user) }
  let(:subject_model) { create(:subject) }
  let!(:topic) { create(:topic, subject: subject_model, name: "元の論点名", description: "元の説明") }

  before { sign_in user }

  it "(Turbo Stream形式で)論点が作成され、一覧に追加されること" do
    expect {
      post subject_topics_path(subject_model),
           params: {
             topic: {
               name: "新しい論点",
               description: "メモ",
               tag_list: "時効, 被保険者"
             }
           },
           as: :turbo_stream
    }.to change(Topic, :count).by(1)

    expect(response.body).to include("turbo-stream action=\"prepend\" target=\"topics_list_subject_#{subject_model.id}\"")
    expect(response.body).to include("新しい論点")
  end

  describe "GET /subjects/:subject_id/topics/:id/edit" do
    it "モーダルにレイアウトなしでレスポンスが返ること" do
      get edit_subject_topic_path(subject_model, topic)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("turbo-frame id=\"modal\"")
      expect(response.body).to include("元の論点名")
    end
  end

  describe "PATCH /subjects/:subject_id/topics/:id" do
    let(:new_params) do
      {
        topic: {
          name: "更新後の論点名",
          description: "更新後の説明",
          tag_list: "重要, 変更あり"
        }
      }
    end

    context "Turbo Stream形式の場合" do
      it "論点が更新され、一覧が置換される命令が返ること" do
        patch subject_topic_path(subject_model, topic), params: new_params, as: :turbo_stream

        topic.reload
        expect(topic.name).to eq "更新後の論点名"
        expect(topic.tags.map(&:name)).to include("重要")

        expect(response).to have_http_status(:success)
        expect(response.body).to include("turbo-stream action=\"replace\" target=\"topic_#{topic.id}\"")
        expect(response.body).to include("更新後の論点名")
        expect(response.body).to include("turbo-stream action=\"update\" target=\"modal\"")
      end
    end

    context "バリデーションエラーの場合" do
      it "422エラーが返り、編集画面が再表示されること" do
        patch subject_topic_path(subject_model, topic),
              params: { topic: { name: "" } },
              as: :turbo_stream

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include("turbo-frame id=\"modal\"")
      end
    end
  end
end
