class TopicsController < ApplicationController
  def new
    @subject = Subject.find(params[:subject_id])
    @topic = @subject.topics.build
  end

  def create
    @subject = Subject.find(params[:subject_id])
    @topic = @subject.topics.build(topic_params)

    if @topic.save
      redirect_to subject_path(@subject), notice: '論点の登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description)
  end
end
