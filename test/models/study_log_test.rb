require "test_helper"

class StudyLogTest < ActiveSupport::TestCase
  def setup
    @user = User.find_by(email: "test_user@example.com") || 
          User.create!(email: "test_user@example.com", password: "password", password_confirmation: "password")
    @exam = Exam.find_or_create_by!(name: "社労士")
    @subject = Subject.find_or_create_by!(name: "労働法", exam: @exam)
    @topic = Topic.find_or_create_by!(name: "労働条件の明示", subject: @subject)
  end

  test "問題なく学習記録が作成されるか" do
    log = StudyLog.new(
      user: @user,
      topic: @topic,
      understanding_level: "not_understood",
      study_on: Date.today
    )
    assert log.valid?
  end

  test "ユーザーがない場合はエラーになるか" do
    log = StudyLog.new(
      topic: @topic,
      understanding_level: "not_understood",
      study_on: Date.today
    )
    assert_not log.valid?
  end

  test "トピックがない場合はエラーになるか" do
    log = StudyLog.new(
      user: @user,
      understanding_level: "not_understood",
      study_on: Date.today
    )
    assert_not log.valid?
  end

  test "学習記録の理解度がない場合はエラーになるか" do
    log = StudyLog.new(
      user: @user,
      topic: @topic,
      understanding_level: nil,
      study_on: Date.today
    )
    assert_not log.valid?
  end
end
