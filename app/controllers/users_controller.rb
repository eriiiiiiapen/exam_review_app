class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  
    @stats = @user.study_logs.where(study_on: 1.year.ago..Date.today)
                  .group(:study_on).count
  end
end
