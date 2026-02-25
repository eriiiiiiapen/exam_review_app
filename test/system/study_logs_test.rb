require "application_system_test_case"

class StudyLogsTest < ApplicationSystemTestCase
  setup do
    @user = User.find_by(email: "test_user@example.com") ||
          User.create!(email: "test_user@example.com", password: "password", password_confirmation: "password")
    @exam = Exam.find_or_create_by!(name: "社労士")
    @subject = Subject.find_or_create_by!(name: "労働法", exam: @exam)
    @topic = Topic.find_or_create_by!(name: "労働条件の明示", subject: @subject)
  end

  test "論点ボタンをクリックすると理解度が進む" do
    visit subject_path(@subject)

    assert_text "未着手"

    click_on "未着手"
    assert_text "なんとなく"

    click_on "なんとなく"
    assert_text "まあ理解"

    click_on "まあ理解"
    assert_text "完璧"

    assert_equal 3, @topic.study_logs.count
  end
end
