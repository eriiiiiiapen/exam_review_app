class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:id]) || current_user

    @start_date = 365.days.ago.to_date
    @end_date = Date.today

    @stats = @user.study_logs
                  .where(study_on: @start_date..@end_date)
                  .group(:study_on)
                  .count

    @total_count = @stats.values.sum
    @max_count = @stats.values.max || 0
    @streak = calculate_streak(@user)

    @subject_stats = @user.study_logs
                          .joins(topic: :subject)
                          .group("subjects.name")
                          .count
  end

  private

  def calculate_streak(user)
    streak = 0
    check_date = Date.today

    loop do
      if user.study_logs.where(study_on: check_date).exists?
        streak += 1
        check_date -= 1
      else
        # 今日x、昨日x →0
        # 今日x、昨日⚪︎ →昨日の分まで
        break if check_date < Date.today
        check_date -= 1
      end
    end
    streak
  end
end
