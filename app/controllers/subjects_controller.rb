class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    @topics = @subject.topics
  end
end
