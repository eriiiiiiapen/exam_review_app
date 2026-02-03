require 'rails_helper'

RSpec.describe "Exams", type: :request do
  let!(:exam) { create(:exam, name: "社労士") }
  let!(:subject_labor) { create(:subject, exam: exam, name: "労働基準法") }
  let!(:subject_health) { create(:subject, exam: exam, name: "健康保険法") }

  describe "GET /exams/:id" do
    it "正常にレスポンスを返し、科目一覧が表示されていること" do
      get exam_path(exam)

      expect(response).to have_http_status(:success)
      expect(response.body).to include("社労士")
      expect(response.body).to include("労働基準法")
      expect(response.body).to include("健康保険法")
    end
  end
end