class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:id]) || current_user

    @start_date = 140.days.ago.to_date
    @end_date = Date.today
  
    @stats = @user.study_logs
                  .where(study_on: @start_date..@end_date)
                  .group(:study_on)
                  .count
  end
end
