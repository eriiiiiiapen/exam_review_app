require 'rails_helper'

RSpec.describe "StudyLogs", type: :request do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }

    before do
        sign_in user
    end

    describe "PATCH /create_or_update" do
        let(:params) do
            {
                study_log: {
                    understanding_level: "understood",
                    note: "テストでの回答"
                }
            }
        end

        it "学習ログが保存されること" do
            expect {
            patch create_or_update_topic_study_log_path(topic), params: params, as: :turbo_stream
            }.to change(StudyLog, :count).by(1)

            expect(response.media_type).to eq "text/vnd.turbo-stream.html"
            expect(response).to have_http_status(:ok)
        end
    end

    describe "PATCH /create_or_update（更新）" do
        let!(:existing_log) { create(:study_log, user: user, topic: topic, note: "古いメモ") }

        let(:update_params) do
            {
                study_log: {
                    understanding_level: "mastered",
                    note: "新しいメモ"
                }
            }
        end

        it "学習ログが更新されること" do
            expect {
            patch create_or_update_topic_study_log_path(topic), params: update_params, as: :turbo_stream
            }.not_to change(StudyLog, :count)

            existing_log.reload
            expect(existing_log.understanding_level).to eq "mastered"
            expect(existing_log.note).to eq "新しいメモ"

            expect(response.media_type).to eq "text/vnd.turbo-stream.html"
            expect(response).to have_http_status(:ok)
        end
    end

    describe "PATCH /create_or_update（異常系）" do
        let!(:existing_log) { create(:study_log, user: user, topic: topic, note: "古いメモ") }

        let(:invalid_params) do
            {
                study_log: {
                    understanding_level: "",
                    note: "新しいメモ"
                }
            }
        end

        it "バリデーションエラーで既存のデータが書き換わらないこと" do
            expect {
            patch create_or_update_topic_study_log_path(topic), params: invalid_params, as: :turbo_stream
            }.not_to change(StudyLog, :count)

            expect(response).to have_http_status(:unprocessable_entity) #422

            existing_log.reload
            expect(existing_log.understanding_level).to eq "not_understood"
            expect(existing_log.note).to eq "古いメモ"
        end
    end
end
